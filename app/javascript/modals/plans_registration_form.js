const showFormButtons = document.getElementsByClassName("showForm");
const closeFormButton = document.getElementById("closeForm");
const dialog = document.getElementById("favDialog");
let url;
let method;
dialog.returnValue = "favAnimal";

function openCheck(dialog) {
  if (dialog.open) {
    console.log("Dialog open");
  } else {
    console.log("Dialog closed");
  }
}

let i;

// Update button opens a modal dialog
for(i = 0; i < showFormButtons.length; i++) {
  showFormButtons[i].addEventListener("click", function(event) {
    const clickedElement = event.target;
    const form = document.querySelector("form");

    const name_field = document.getElementById("plan_name");
    const starting_day_of_week_field = document.getElementById("plan_starting_day_of_week");
    const starting_hour_field = document.getElementById("plan_starting_time_before_type_conversion_4i");
    const starting_minute_field = document.getElementById("plan_starting_time_before_type_conversion_5i");
    const ending_day_of_week_field = document.getElementById("plan_ending_day_of_week");
    const ending_hour_field = document.getElementById("plan_ending_time_before_type_conversion_4i");
    const ending_minute_field = document.getElementById("plan_ending_time_before_type_conversion_5i");

    let plan;
    let plan_object;
    let new_plan_object;
    let new_plan;
    let plan_start_object;
    let plan_start;
    console.log("-------------");
    console.log("要素を取得します。");
    console.log("クリックした要素　↓");
    console.log(clickedElement);
    if(clickedElement.classList[2] != null) {
      console.log("識別子planかplanIdsHashか： " + clickedElement.classList[1] + ", 識別子+Id： " + clickedElement.classList[1] + clickedElement.classList[2]);
      plan_object = document.getElementById(clickedElement.classList[1] + clickedElement.classList[2]);
      console.log("plan_object ↓");
      console.log(plan_object);
      plan = JSON.parse(plan_object.value);
      
      // url = document.getElementById("updateURL").value;
      url = document.getElementById("updateURL_" + clickedElement.classList[2]).value;
      method = document.getElementById("updateMethod").value;
      console.log("plan ↓");
      console.log(plan);
    } else {
      new_plan_object = document.getElementById("newPlan");
      plan_start_object = document.getElementById("startTime_" + clickedElement.id);
      console.log("new_plan_object ↓");
      console.log(new_plan_object);
      console.log("plan_start_object ↓");
      console.log(plan_start_object);

      new_plan = JSON.parse(new_plan_object.value);
      console.log("new_plan ↓");
      console.log(new_plan);
      plan_start = JSON.parse(plan_start_object.value);
      console.log("plan_start ↓");
      console.log(plan_start);
      url = document.getElementById("createURL").value;
      method = document.getElementById("createMethod").value;
    };
    console.log("form:");
    console.log(form);
    console.log("form.action:");
    console.log(form.action);
    console.log(`url: ${url}`);
    console.log(`method: ${method}`);

    console.log("formの中身を書き換えます");

    form.action = url;
    form.method = method;

    if(clickedElement.classList[2] != null) {
      console.log("plan: " + plan);
      console.log("plan[name]: " + plan["name"]);
      name_field.value = plan["name"];
      starting_day_of_week_field.value = plan["starting_day_of_week"];
      starting_hour_field.value = plan["starting_time"].substring(0, 2);
      starting_minute_field.value = plan["starting_time"].substring(3, 5);
      ending_day_of_week_field.value = plan["ending_day_of_week"];
      ending_hour_field.value = plan["ending_time"].substring(0, 2);
      ending_minute_field.value = plan["ending_time"].substring(3, 5);
    } else {
      name_field.value = "";
      starting_day_of_week_field.value = plan_start["starting_day_of_week"];
      console.log('plan_start["starting_day_of_week"]: ' + plan_start["starting_day_of_week"]);
      console.log("新プラン開始曜日: " + starting_day_of_week_field.value);
      console.log('plan_start["starting_hour"]: ' + plan_start["starting_hour"]);
      console.log('plan_start["starting_minute"]: ' + plan_start["starting_minute"]);
      starting_hour_field.value = plan_start["starting_hour"];
      starting_minute_field.value = plan_start["starting_minute"];
      ending_day_of_week_field.value = "";
      ending_hour_field.value = "";
      ending_minute_field.value = "";
    };

    console.log("各フォームの初期値を書き換えた結果を出力");
    console.log("form:");
    console.log(form);
    console.log("プラン名: " + name_field.value);
    console.log("開始曜日: " + starting_day_of_week_field.value);
    console.log("開始時間: " + starting_hour_field.value + ":" + starting_minute_field.value);
    console.log("終了曜日: " + ending_day_of_week_field.value);
    console.log("終了時間: " + ending_hour_field.value + ":" + ending_minute_field.value);

    dialog.showModal();
    openCheck(dialog);
  });
};

// Form cancel button closes the dialog box
closeFormButton.addEventListener("click", () => {
  dialog.close();
  openCheck(dialog);
});