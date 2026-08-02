<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    #dm-chat-widget {
        position: fixed;
        bottom: 24px;
        right: 90px; /* Positioned to the left of AI assistant */
        z-index: 1000;
        font-family: 'Inter', sans-serif;
    }
    .dm-chat-btn {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background: linear-gradient(135deg, #00C6FF, #0072FF);
        color: white;
        border: none;
        box-shadow: 0 4px 15px rgba(0, 114, 255, 0.4);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        transition: transform 0.2s;
    }
    .dm-chat-btn:hover {
        transform: scale(1.05);
    }
    .dm-chat-window {
        display: none;
        position: absolute;
        bottom: 80px;
        right: 0;
        width: 350px;
        height: 500px;
        background: var(--bg-main);
        border: 1px solid var(--border-color);
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        overflow: hidden;
        flex-direction: column;
    }
    .dm-header {
        background: linear-gradient(135deg, #00C6FF, #0072FF);
        padding: 16px;
        color: white;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .dm-header h4 { margin: 0; font-size: 16px; font-weight: 600; cursor: pointer; }
    .dm-header .dm-close { cursor: pointer; font-size: 20px; }
    .dm-body {
        flex: 1;
        overflow-y: auto;
        padding: 0;
        background: var(--bg-main);
    }
    .dm-conversations-list { list-style: none; padding: 0; margin: 0; }
    .dm-conv-item {
        display: flex;
        padding: 12px 16px;
        border-bottom: 1px solid var(--border-color);
        cursor: pointer;
        transition: background 0.2s;
    }
    .dm-conv-item:hover { background: var(--bg-surface-hover); }
    .dm-conv-avatar {
        width: 48px;
        height: 48px;
        border-radius: 50%;
        margin-right: 12px;
        object-fit: cover;
    }
    .dm-conv-info { flex: 1; overflow: hidden; }
    .dm-conv-name { margin: 0 0 4px 0; font-weight: 600; color: var(--text-main); font-size: 15px; }
    .dm-conv-lastmsg { margin: 0; color: var(--text-muted); font-size: 13px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    
    .dm-chat-area { display: none; height: 100%; flex-direction: column; }
    .dm-messages { flex: 1; padding: 16px; overflow-y: auto; display: flex; flex-direction: column; gap: 8px; }
    .dm-msg { max-width: 75%; padding: 10px 14px; border-radius: 18px; font-size: 14px; line-height: 1.4; word-wrap: break-word; }
    .dm-msg.sent { background: #0072FF; color: white; align-self: flex-end; border-bottom-right-radius: 4px; }
    .dm-msg.received { background: #1e293b; color: var(--text-main); align-self: flex-start; border-bottom-left-radius: 4px; border: 1px solid var(--border-color); }
    
    .dm-input-area {
        padding: 12px;
        background: #1e293b;
        border-top: 1px solid var(--border-color);
        display: flex;
        gap: 8px;
    }
    .dm-input-area input {
        flex: 1;
        padding: 10px 14px;
        border: 1px solid var(--border-color);
        border-radius: 20px;
        background: var(--bg-main);
        color: var(--text-main);
        outline: none;
    }
    .dm-input-area button {
        background: #0072FF;
        color: white;
        border: none;
        border-radius: 50%;
        width: 40px;
        height: 40px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .dm-unread-badge {
        background: #ef4444;
        color: white;
        font-size: 11px;
        padding: 2px 6px;
        border-radius: 10px;
        margin-left: auto;
    }
    .dm-total-unread-badge {
        position: absolute;
        top: -5px;
        right: -5px;
        background: #ef4444;
        color: white;
        font-size: 12px;
        font-weight: bold;
        padding: 4px 8px;
        border-radius: 50%;
        border: 2px solid var(--bg-main);
        display: none;
    }
</style>

<div id="dm-chat-widget">
    <div style="position: relative;">
        <button class="dm-chat-btn" onclick="toggleDmWindow()">
            💬
        </button>
        <span id="dmTotalUnreadBadge" class="dm-total-unread-badge">0</span>
    </div>
    <div class="dm-chat-window" id="dmChatWindow">
        <div class="dm-header">
            <h4 id="dmHeaderTitle" onclick="showConversationsList()">Tin nhắn</h4>
            <span class="dm-close" onclick="toggleDmWindow()">×</span>
        </div>
        
        <!-- Conversations List -->
        <div class="dm-body" id="dmConversationsView">
            <ul class="dm-conversations-list" id="dmConversationsList">
                <div style="padding: 20px; text-align: center; color: var(--text-muted);">Đang tải...</div>
            </ul>
        </div>
        
        <!-- Active Chat -->
        <div class="dm-chat-area" id="dmChatView">
            <div class="dm-messages" id="dmMessages">
                <!-- Messages go here -->
            </div>
            <div class="dm-input-area">
                <input type="text" id="dmInput" placeholder="Nhập tin nhắn..." onkeypress="if(event.key === 'Enter') sendDm()">
                <button onclick="sendDm()">➤</button>
            </div>
        </div>
    </div>
</div>

<script>
    let dmPollingInterval = null;
    let currentChatUserId = null;
    const currentUserId = ${sessionScope.user != null ? sessionScope.user.id : 'null'};

    function toggleDmWindow() {
        if (!currentUserId) {
            alert('Vui lòng đăng nhập để sử dụng tính năng nhắn tin.');
            return;
        }
        const win = document.getElementById('dmChatWindow');
        if (win.style.display === 'flex') {
            win.style.display = 'none';
        } else {
            win.style.display = 'flex';
            showConversationsList();
        }
    }

    function showConversationsList() {
        document.getElementById('dmConversationsView').style.display = 'block';
        document.getElementById('dmChatView').style.display = 'none';
        document.getElementById('dmHeaderTitle').innerText = 'Tin nhắn';
        currentChatUserId = null;
        fetchConversations();
    }

    function openChatWithUser(userId, userName) {
        if (!currentUserId) {
            alert('Vui lòng đăng nhập để nhắn tin.');
            return;
        }
        
        // Ensure window is open
        const win = document.getElementById('dmChatWindow');
        if (win.style.display !== 'flex') {
            win.style.display = 'flex';
        }
        
        currentChatUserId = userId;
        document.getElementById('dmConversationsView').style.display = 'none';
        document.getElementById('dmChatView').style.display = 'flex';
        document.getElementById('dmHeaderTitle').innerHTML = '← ' + userName;
        
        document.getElementById('dmMessages').innerHTML = '<div style="text-align:center;color:gray;margin-top:20px;">Đang tải...</div>';
        fetchMessages();
    }

    function fetchConversations() {
        fetch('${pageContext.request.contextPath}/api/chat/conversations')
            .then(res => res.json())
            .then(data => {
                if(data.error) return;
                
                let totalUnread = 0;
                
                const list = document.getElementById('dmConversationsList');
                list.innerHTML = '';
                if(data.length === 0) {
                    list.innerHTML = '<div style="padding: 20px; text-align: center; color: var(--text-muted);">Chưa có cuộc trò chuyện nào.</div>';
                } else {
                    data.forEach(conv => {
                        totalUnread += conv.unreadCount;
                        const avatar = conv.otherUserAvatarUrl ? conv.otherUserAvatarUrl : `https://ui-avatars.com/api/?name=`+encodeURIComponent(conv.otherUserName)+`&background=random`;
                        const unreadBadge = conv.unreadCount > 0 ? `<span class="dm-unread-badge">\${conv.unreadCount}</span>` : '';
                        list.innerHTML += `
                            <li class="dm-conv-item" onclick="openChatWithUser(\${conv.otherUserId}, '\${conv.otherUserName}')">
                                <img src="\${avatar}" class="dm-conv-avatar">
                                <div class="dm-conv-info">
                                    <h4 class="dm-conv-name">\${conv.otherUserName}</h4>
                                    <p class="dm-conv-lastmsg">\${conv.lastMessage}</p>
                                </div>
                                \${unreadBadge}
                            </li>
                        `;
                    });
                }
                
                // Update total badge
                const badge = document.getElementById('dmTotalUnreadBadge');
                if (totalUnread > 0) {
                    badge.style.display = 'block';
                    badge.innerText = totalUnread > 99 ? '99+' : totalUnread;
                } else {
                    badge.style.display = 'none';
                }
            });
    }

    function fetchMessages() {
        if (!currentChatUserId) return;
        fetch('${pageContext.request.contextPath}/api/chat/messages?userId=' + currentChatUserId)
            .then(res => res.json())
            .then(data => {
                if(data.error) return;
                const msgBox = document.getElementById('dmMessages');
                const isScrolledToBottom = msgBox.scrollHeight - msgBox.clientHeight <= msgBox.scrollTop + 10;
                
                let html = '';
                data.forEach(msg => {
                    const type = msg.senderId === currentUserId ? 'sent' : 'received';
                    html += `<div class="dm-msg \${type}">\${msg.content}</div>`;
                });
                msgBox.innerHTML = html;
                
                if (isScrolledToBottom) {
                    msgBox.scrollTop = msgBox.scrollHeight;
                }
            });
    }

    function sendDm() {
        const input = document.getElementById('dmInput');
        const content = input.value.trim();
        if (!content || !currentChatUserId) return;
        
        input.value = '';
        
        // Optimistic UI update
        const msgBox = document.getElementById('dmMessages');
        msgBox.innerHTML += `<div class="dm-msg sent">\${content}</div>`;
        msgBox.scrollTop = msgBox.scrollHeight;

        fetch('${pageContext.request.contextPath}/api/chat/send', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'receiverId=' + currentChatUserId + '&content=' + encodeURIComponent(content)
        }).then(res => res.json()).then(data => {
            if(!data.success) {
                alert('Không thể gửi tin nhắn.');
            }
        });
    }

    function startPolling() {
        if (dmPollingInterval) clearInterval(dmPollingInterval);
        dmPollingInterval = setInterval(() => {
            if (currentUserId) {
                if (currentChatUserId) {
                    fetchMessages();
                }
                fetchConversations();
            }
        }, 3000); // Poll every 3 seconds
    }

    function stopPolling() {
        if (dmPollingInterval) clearInterval(dmPollingInterval);
    }
    
    // Start global polling if user is logged in
    if (currentUserId) {
        startPolling();
        fetchConversations();
    }
</script>
