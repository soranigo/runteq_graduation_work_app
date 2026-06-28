import consumer from "channels/consumer"
import { showNotification, requestNotificationPermission } from "../notifications"

console.log("📂 notifications_channel.js が読み込まれました");

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("✅ 通知チャンネルに接続しました");
    
    // 接続時に通知許可をリクエスト（初回のみ）
    requestNotificationPermission();
  },

  disconnected() {
    console.log("❌ 通知チャンネルから切断しました");
  },

  received(data) {
    console.log("📩 通知データを受信:", data);
    
    // サーバーからの通知指示を受け取った
    //if (data.type === 'web_notification') {
      console.log("🔔 Web通知を表示します");
      this.handleWebNotification(data);
    //}
  },

  handleWebNotification(data) {
    // notifications.jsの関数を使って通知を表示
    showNotification(data.title, data.body, {
      tag: `schedule-${data.schedule_id}`,
      icon: data.icon || '/icon.png',
      autoClose: true,
      closeDelay: 5000,
      onClick: () => {
        // 通知クリック時の処理
        if (data.url) {
          window.location.href = data.url;
        }
      }
    });
  }
});
