from flask import request

def request_judge(req: request, *args) -> bool:
    if not req.json:
        return True
    for a in args:
        if a not in request.json:
            return True
    return False
