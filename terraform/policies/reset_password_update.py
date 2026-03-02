if request.context["pending_user"].attributes.get("reset_password") == True:
    request.context["pending_user"].attributes["reset_password"] = False
    return True

return False
