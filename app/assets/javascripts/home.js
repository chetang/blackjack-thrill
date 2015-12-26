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