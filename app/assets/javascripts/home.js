// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
// # homePageModule = {}
// # (->
// #   @init = ->
// #   	$('#login-submit').on 'click', ->
// #   		email = $("#user-email-login").val()
// #   		# // validate email id
// #   		alert "email address is #{email}"
// #     # $('#mobile-view-search-icon').on 'click', ->
// #     #   $('.ovarlay').show()
// #     #   $('.mobile-search-div').animate top: 0
// #     #   $('input#mobile-view-search-input').focus()
// #     #   return
// #     # $('.mobile-search-div .mobile-search-back-icon').on 'click', ->
// #     #   $('.ovarlay').hide()
// #     #   $('.mobile-search-div').animate top: '-60px'
// #     #   $('.mobile-search-suggestions').hide()
// #     #   return
// #     # $(window).scroll ->
// #     #   top = $(this).scrollTop()
// #     #   page = $('#page-description').val()
// #     #   if page == 'home'
// #     #     if top > 50 and $('.transparent').length > 0
// #     #       $('.transparent').addClass 'not_transparent'
// #     #       $('.transparent').removeClass 'transparent'
// #     #     else if top <= 50 and $('.not_transparent').length > 0
// #     #       $('.not_transparent').addClass 'transparent'
// #     #       $('.not_transparent').removeClass 'not_transparent'
// #     #   return
// #     return

// #   # @check_sell = (category) ->
// #   #   if loginModule.user_signed_in()
// #   #     true
// #   #   else
// #   #     loginModule.modify_login_url 'action_type': 'products/new'
// #   #     Utils.open_modal 'loginModal'
// #   #     false

// #   # @showCategories = ->
// #   #   if $('.main-step-2').length > 0
// #   #     $('.main-step-1').fadeOut 300, ->
// #   #       $('.main-step-2').fadeIn()
// #   #       return
// #   #     false
// #   #   else
// #   #     true

// #   # @hideCategories = ->
// #   #   $('.main-step-2').fadeOut 300, ->
// #   #     $('.main-step-1').fadeIn()
// #   #     return
// #   #   return

// #   return
// # ).apply homePageModule

var homePageModule = {};

(function() {
    this.init = function(){
        $('.login-user-form').submit(function(){
            email = $("#user_email").val()
            validResult = homePageModule.validateEmail(email);
            if (!validResult){
              alert("Please type a valid email Id")
              return false;
            }
        });
    };

    this.validateEmail = function(email){
      var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return re.test(email);
    }

}).apply(homePageModule);