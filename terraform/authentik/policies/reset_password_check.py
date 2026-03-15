if request.context["pending_user"].attributes.get("reset_password") == True or request.context["pending_user"].attributes.get("password_reset") == True:
    return True

return False
