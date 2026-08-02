<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Global Floating Icons -->
<div class="floating-icon fi-1">🎤</div>
<div class="floating-icon fi-2">🥁</div>
<div class="floating-icon fi-3">🎵</div>
<div class="floating-icon fi-4">🎺</div>
<div class="floating-icon fi-5">🎧</div>
<div class="floating-icon fi-6">🎶</div>
<div class="floating-icon fi-7">🎹</div>
<div class="floating-icon fi-8">🎸</div>
<div class="floating-icon fi-9">🎷</div>
<div class="floating-icon fi-10">🎼</div>

<footer>
    <div class="container">
        <p>&copy; 2026 TalentConnect - Dự án kết nối tài năng nghệ thuật và nhà tuyển dụng.</p>
        <p style="font-size: 12px; color: var(--text-muted);">Phát triển bởi Nhóm 3 Chàng Lính Ngự Lâm - Lớp SD2001 (UDPM - JAVA)</p>
    </div>

    <!-- Floating Chatbot UI -->
    <div id="chatbot-container" style="position: fixed; bottom: 20px; right: 20px; z-index: 9999;">
        <!-- Chatbox -->
        <div id="chatbox" style="display: none; width: 320px; background: var(--bg-card); border-radius: var(--radius-sm); box-shadow: var(--shadow-lg); border: 1px solid var(--border-color); overflow: hidden; margin-bottom: 16px; flex-direction: column;">
            <div style="background: var(--primary); color: white; padding: 16px; font-weight: 600; font-family: var(--font-heading); display: flex; justify-content: space-between; align-items: center;">
                <span>🤖 Talent AI Assistant</span>
                <button onclick="toggleChat()" style="background: transparent; border: none; color: white; cursor: pointer; font-size: 16px;">✕</button>
            </div>
            <div id="chat-messages" style="height: 300px; overflow-y: auto; padding: 16px; display: flex; flex-direction: column; gap: 12px; font-size: 14px;">
                <div style="align-self: flex-start; background: rgba(0,0,0,0.05); padding: 10px 14px; border-radius: 12px; max-width: 85%;">
                    Xin chào! Mình có thể giúp gì cho bạn?
                </div>
            </div>
            <div style="padding: 12px; border-top: 1px solid var(--border-color); display: flex; gap: 8px;">
                <input type="text" id="chat-input" placeholder="Hỏi AI tìm show..." style="flex: 1; padding: 8px 12px; border: 1px solid var(--border-color); border-radius: var(--radius-full); font-size: 14px; outline: none;">
                <button onclick="sendMessage()" style="background: var(--primary); color: white; border: none; border-radius: var(--radius-full); width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; cursor: pointer;">
                    ➤
                </button>
            </div>
        </div>
        
        <!-- Toggle Button -->
        <button id="chatbot-toggle" onclick="toggleChat()" style="width: 56px; height: 56px; border-radius: 50%; background: var(--primary); color: white; border: none; box-shadow: var(--shadow-md); cursor: pointer; font-size: 24px; display: flex; align-items: center; justify-content: center; margin-left: auto;">
            💬
        </button>
    </div>

    <script>
        function toggleChat() {
            const chatbox = document.getElementById('chatbox');
            if (chatbox.style.display === 'none' || chatbox.style.display === '') {
                chatbox.style.display = 'flex';
            } else {
                chatbox.style.display = 'none';
            }
        }

        function sendMessage() {
            const input = document.getElementById('chat-input');
            const message = input.value.trim();
            if (!message) return;

            const chatMessages = document.getElementById('chat-messages');
            
            // Append User Message
            const userDiv = document.createElement('div');
            userDiv.style = "align-self: flex-end; background: var(--primary); color: white; padding: 10px 14px; border-radius: 12px; max-width: 85%;";
            userDiv.innerText = message;
            chatMessages.appendChild(userDiv);
            
            input.value = '';
            chatMessages.scrollTop = chatMessages.scrollHeight;

            // Show Typing indicator (optional)
            
            // Send to Servlet
            const formData = new URLSearchParams();
            formData.append("message", message);
            
            fetch('${pageContext.request.contextPath}/api/chatbot', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                const aiDiv = document.createElement('div');
                aiDiv.style = "align-self: flex-start; background: rgba(0,0,0,0.05); padding: 10px 14px; border-radius: 12px; max-width: 85%; line-height: 1.5;";
                aiDiv.innerHTML = data.reply;
                chatMessages.appendChild(aiDiv);
                chatMessages.scrollTop = chatMessages.scrollHeight;
                
                if (data.redirectUrl) {
                    setTimeout(() => {
                        window.location.href = data.redirectUrl;
                    }, 2000);
                }
            })
            .catch(err => {
                console.error(err);
                const errDiv = document.createElement('div');
                errDiv.style = "align-self: flex-start; background: #fee2e2; color: #ef4444; padding: 10px 14px; border-radius: 12px; max-width: 85%; font-size: 12px;";
                errDiv.innerText = "Lỗi kết nối tới AI.";
                chatMessages.appendChild(errDiv);
            });
        }
        
        document.getElementById('chat-input').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });
    </script>
    
    <!-- Include Direct Messaging System -->
    <jsp:include page="/WEB-INF/views/chatbox.jsp" />
</footer>
