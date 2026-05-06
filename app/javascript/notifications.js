let notification;

export function requestNotificationPermission() {
  // 通知機能がサポートされているか確認
  if (!("Notification" in window)) {
    alert("このブラウザは通知機能に対応していません");
    return;
  }

  // まだ許可を求めていない場合
  if (Notification.permission === "default") {
    Notification.requestPermission().then(permission => {
      if (permission === "granted") {
        console.log("通知が許可されました");
      } else {
        console.log("通知が拒否されました");
      }
      return permission;
    });
  }

  // すでに許可/拒否されている場合
  return Promise.resolve(Notification.permission);
}

// 通知を表示する関数
export function showNotification(title, body, tag) {
  if (Notification.permission === "granted") {
    notification = new Notification(title, {
      body: body,
      tag: String(tag) + "&" + String(Math.random(100000))
    });
  }

  // 通知がクリックされたときの処理
  notification.onclick = function(event) {
    event.preventDefault();
    window.focus(); // ウィンドウをフォーカス
    if (options.onClick) {
      options.onClick();
    }
    notification.close();
  };

  // 任意のタイミングで自動的に通知を閉じる例
  setTimeout(() => {
    closeNotification();
  }, 5000); // 5秒後に通知を閉じる

  return notification;
}

// 通知を閉じる関数
function closeNotification() {
  if (notification) {
    notification.close();
    notification = null; // メモリ管理のためにクリア
  }
}
