if request.context["pending_user"].attributes.get("reset_password") == True:
    request.context["pending_user"].attributes["reset_password"] = False
    return True

if request.context["pending_user"].attributes.get("password_reset") == True:
    request.context["pending_user"].attributes["password_reset"] = False
    return True

return False
