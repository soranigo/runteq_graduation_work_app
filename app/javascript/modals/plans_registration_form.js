/*
const showFormButtons = document.getElementsByClassName("showForm");
const closeFormButton = document.getElementById("closeForm");
const dialog = document.getElementById("favDialog");
const testButtons = document.getElementsByClassName("test");

const form = document.querySelector("form");
*/

// dialog.returnValue = "favAnimal";

let form_method_input;

function openCheck(dialog) {
  if (dialog.open) {
    console.log("Dialog open");
  } else {
    console.log("Dialog closed");
  }
}

let i;

/*
for(i = 0; i < testButtons.length; i++) {
  testButtons[i].addEventListener("click", () => {
    console.log("testだよ");
  });
};
*/

// Update button opens a modal dialog
document.addEventListener("click", function(event) {
  const clickedElement = event.target;

  if (!clickedElement.classList.contains("showForm")) return;

  const dialog = document.getElementById("favDialog");
  const form = document.querySelector("form");

  const name_field = document.getElementById("plan_name");
  const starting_day_of_week_field = document.getElementById("plan_starting_day_of_week");
  const starting_hour_field = document.getElementById("plan_starting_time_before_type_conversion_4i");
  const starting_minute_field = document.getElementById("plan_starting_time_before_type_conversion_5i");
  const ending_day_of_week_field = document.getElementById("plan_ending_day_of_week");
  const ending_hour_field = document.getElementById("plan_ending_time_before_type_conversion_4i");
  const ending_minute_field = document.getElementById("plan_ending_time_before_type_conversion_5i");

  let plan_object;
  let plan;
  let plan_start_object;
  let plan_start;
  let url;

  form.method = "post";

  console.log("-------------");
  console.log("要素を取得します。");
  console.log("クリックした要素 ↓");
  console.log(clickedElement);
  if(clickedElement.classList[2] != null) {
    plan_object = document.getElementById(clickedElement.classList[1] + clickedElement.classList[2]);
    plan = JSON.parse(plan_object.value);
    url = document.getElementById("updateURL_" + clickedElement.classList[2]).value;

    form_method_input = form.querySelector("input[name='_method']");
    console.log("form_method_input ↓");
    console.log(form_method_input);

    if(form_method_input == null) {
      console.log("送信先切り替え用オブジェクトが無かったため、生成します。");
      form_method_input = document.createElement('input');
      form_method_input.type = 'hidden';
      form_method_input.name = '_method';
      form_method_input.value = 'patch';
      form.appendChild(form_method_input);
    };

    let debug;
    let j;

    debug = (document.querySelectorAll("input[name='_method']"));

    console.log("取得したinput一覧");
    for(j = 0; j < debug.length ; j++) {
      console.log(debug[j]);
    };
  } else {
    plan_object = document.getElementById("newPlan");
    plan_start_object = document.getElementById("startTime_" + clickedElement.id);
    plan = JSON.parse(plan_object.value);
    plan_start = JSON.parse(plan_start_object.value);

    plan["ending_time"] = String((Number(plan_start["starting_hour"]) + 1) % 24).padStart(2,'0') + ":" + plan_start["starting_minute"];

    if(plan_start["starting_hour"] >= 23) {
      plan["ending_day_of_week"] = plan_start["days_of_week"][(Number(plan_start["day"]) + 1) % 7];
    } else {
      plan["ending_day_of_week"] = plan_start["days_of_week"][plan_start["day"]];
    };

    plan["starting_day_of_week"] = plan_start["days_of_week"][plan_start["day"]];
    plan["starting_time"] = plan_start["starting_hour"] + ":" + plan_start["starting_minute"];

    url = document.getElementById("createURL").value;
    form_method_input = form.querySelector("input[name='_method']");
  };

  form.action = url;

  name_field.value = plan["name"];
  starting_day_of_week_field.value = plan["starting_day_of_week"];
  starting_hour_field.value = plan["starting_time"].substring(0, 2);
  starting_minute_field.value = plan["starting_time"].substring(3, 5);
  ending_day_of_week_field.value = plan["ending_day_of_week"];
  ending_hour_field.value = plan["ending_time"].substring(0, 2);
  ending_minute_field.value = plan["ending_time"].substring(3, 5);

  console.log("form ↓");
  console.log(form);
  console.log("form_method_input ↓");
  console.log(form_method_input);

  dialog.showModal();
  openCheck(dialog);
});

// Form cancel button closes the dialog box
document.addEventListener("click", function(event) {
  if (event.target.id !== "closeForm") return;

  const dialog = document.getElementById("favDialog");
  const form = document.querySelector("form");
  const form_method_input = form.querySelector("input[name='_method']");

  console.log("削除処理前のform_method_input ↓");
  console.log(form_method_input);

  if(form_method_input) {
    console.log("メソッド切り替え用オブジェクトを削除します。")
    form.removeChild(form_method_input);
  };

  dialog.close();
  openCheck(dialog);
});
