if request.context["pending_user"].attributes.get("reset_password") == True:
    return True

return False
