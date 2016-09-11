$(document).ready(function() {
  var url = "https://raw.githubusercontent.com/kannans/code-challenge-answer/master/scrape/data.json"
  console.log(url)
  $.getJSON( url, function( data ) {
    var totalSize = data.length - 1;
    $.each( data, function( key, val ) {
      var column1 = "<td>" + val.name + "</td>"
      var column2 = "<td>" + val.rank + "</td>"
      var column3 = "<td>" + val["tuition_fees"] + "</td>"
      var column4 = "<td>" + val["total_enrollment"] + "</td>"
      var column5 = "<td>" + val["acceptance_rate"] + "</td>"
      var column6 = "<td>" + val["average_retention_rate"] + "</td>"
      var column7 = "<td>" + val["graduation_rate"] + "</td>"
      $("#item-list").append("<tr>"+column1+column2+column3+column4+column5+column6+column7+"</tr>");
      if (totalSize === key) {
        $('#data-table').DataTable()
      }
    });
  })
});
