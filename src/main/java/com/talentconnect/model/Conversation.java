package com.talentconnect.model;

import java.sql.Timestamp;

public class Conversation {
    private int otherUserId;
    private String otherUserName;
    private String otherUserAvatarUrl;
    private String lastMessage;
    private Timestamp lastMessageTime;
    private int unreadCount;

    public Conversation() {}

    public int getOtherUserId() { return otherUserId; }
    public void setOtherUserId(int otherUserId) { this.otherUserId = otherUserId; }

    public String getOtherUserName() { return otherUserName; }
    public void setOtherUserName(String otherUserName) { this.otherUserName = otherUserName; }

    public String getOtherUserAvatarUrl() { return otherUserAvatarUrl; }
    public void setOtherUserAvatarUrl(String otherUserAvatarUrl) { this.otherUserAvatarUrl = otherUserAvatarUrl; }

    public String getLastMessage() { return lastMessage; }
    public void setLastMessage(String lastMessage) { this.lastMessage = lastMessage; }

    public Timestamp getLastMessageTime() { return lastMessageTime; }
    public void setLastMessageTime(Timestamp lastMessageTime) { this.lastMessageTime = lastMessageTime; }

    public int getUnreadCount() { return unreadCount; }
    public void setUnreadCount(int unreadCount) { this.unreadCount = unreadCount; }
}
