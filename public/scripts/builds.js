function appendfunc(name) {
  return function () {
    var last    = $("#" + name).find("input").last();
    var lastNum = parseInt(last[0].name.match(/\d+/)[0]);

    var elem    = last.clone();
    elem.attr("name", name + "[" + (lastNum +1) + "]");
    elem.attr("value", "");
    $("#" + name).append(elem);
  }
}

$(document).ready(function() {
  $('#new-callback').click(appendfunc("callbacks"));
  $('#new-environment').click(appendfunc("environment"));

  // $('#btnDel').click(function() {
  //   var num = $('.clonedInput').length;

  //   $('#input' + num).remove();
  //   $('#btnAdd').attr('disabled','');

  //   if (num-1 == 1)
  //   $('#btnDel').attr('disabled','disabled');
  // });

  // $('#btnDel').attr('disabled','disabled');
});
