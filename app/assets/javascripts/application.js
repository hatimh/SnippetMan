// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .


$(document).on('turbolinks:load', function() {
  

  var gistsForm = $('.gist-form');

  if (gistsForm) {
    // Function to add new file to gist form
    gistsForm.find('.add-file-button').on('click', function() {
      var gistsContainer = $('.gist-form .files-container');
      var end = gistsContainer.children().length;
  
      var fileNameInput = $('<input>')
        .attr('type', 'text')
        .attr('name', '[gist]files[][name]')
        .attr('placeholder', 'File name with extension')
        .addClass('form-control my-2');
  
      var fileContentInput = $('<textarea>')
        .attr('name', '[gist]files[][content]')
        .attr('placeholder', 'Code')
        .attr('rows', 5)
        .addClass('form-control my-2');
      
      var fileDeleteButton = $('<button>')
        .attr('type', 'button')
        .addClass('delete-file-button btn btn-sm float-right btn-danger mb-4')
        .text('Delete File') 
  
      var newFields = $('<div>')
        .attr('id', 'file-' + (end + 1))
        .addClass('form-group my-4')
        .append(fileNameInput, fileContentInput, fileDeleteButton);
      
      gistsContainer.append(newFields);  
    })

    // Dynamically support existing and newly created delete buttons to take appropriate action
    gistsForm.on('click', '.delete-file-button', function (event) {
      $(event.target).closest('.form-group').remove();
    })
  }
});

// Implement spinner - To do
// $(document).on("turbolinks:request-start", function(){
  
// });

// $(document).on("turbolinks:request-end", function(){
  
// });