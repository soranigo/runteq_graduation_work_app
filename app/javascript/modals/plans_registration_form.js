const showFormButtons = document.getElementsByClassName("showForm");
const closeFormButton = document.getElementById("closeForm");
const dialog = document.getElementById("favDialog");
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

    let plan_object;
    let plan;
    let plan_start_object;
    let plan_start;
    let url;
    let method;

    console.log("-------------");
    console.log("要素を取得します。");
    console.log("クリックした要素　↓");
    console.log(clickedElement);
    if(clickedElement.classList[2] != null) {
      plan_object = document.getElementById(clickedElement.classList[1] + clickedElement.classList[2]);
      plan = JSON.parse(plan_object.value);
    } else {
      plan_object = document.getElementById("newPlan");
      plan_start_object = document.getElementById("startTime_" + clickedElement.id);
      plan = JSON.parse(plan_object.value);
      plan_start = JSON.parse(plan_start_object.value);

      console.log('plan_start["days_of_week"] ↓');
      console.log(plan_start["days_of_week"]);
      console.log('plan_start["days_of_week"][plan_start["day"]] ↓');
      console.log(plan_start["days_of_week"][plan_start["day"]]);

      console.log('ending_time更新前のplan ↓');
      console.log(plan);

      plan["ending_time"] = String((Number(plan_start["starting_hour"]) + 1) % 24).padStart(2,'0') + ":" + plan_start["starting_minute"];

      if(plan_start["starting_hour"] >= 23) {
        plan["ending_day_of_week"] = plan_start["days_of_week"][(Number(plan_start["day"]) + 1) % 7];
      } else {
        plan["ending_day_of_week"] = plan_start["days_of_week"][plan_start["day"]];
      };

      console.log('ending_time更新後のplan ↓');
      console.log(plan);

      plan["starting_day_of_week"] = plan_start["days_of_week"][plan_start["day"]];
      plan["starting_time"] = plan_start["starting_hour"] + ":" + plan_start["starting_minute"];
    };

    console.log("plan ↓");
    console.log(plan);

    name_field.value = plan["name"];
    starting_day_of_week_field.value = plan["starting_day_of_week"];
    starting_hour_field.value = plan["starting_time"].substring(0, 2);
    starting_minute_field.value = plan["starting_time"].substring(3, 5);
    ending_day_of_week_field.value = plan["ending_day_of_week"];
    ending_hour_field.value = plan["ending_time"].substring(0, 2);
    ending_minute_field.value = plan["ending_time"].substring(3, 5);

    dialog.showModal();
    openCheck(dialog);
  });
};

// Form cancel button closes the dialog box
closeFormButton.addEventListener("click", () => {
  dialog.close();
  openCheck(dialog);
});
