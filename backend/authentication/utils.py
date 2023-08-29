import time
from dbconnect import connection,cursor
from authlib.jose import jwt

header = {"alg": "ES256"}

jwk = {
    "kty": "EC",
    "d": "D9U4frZ8QBCieLwa0Fpwl1yTeIu6v_7xOgp8BxZZ6Rc",
    "use": "sig",
    "crv": "P-256",
    "kid": "2IvW6pve3GOXZjZzVkCtrZWUmATgc-KgG_mmtgLe7FI",
    "x": "ZcPZM5rOLR4XxylOFOVh2qy8HxP_mC96Q7eUmM6uhyk",
    "y": "-mFrlXGwHGkY01i7vFb0fZVH3g1q2TbDwBD1zpCRg-M",
    "alg": "ES256"
}

def verifyPassword(email,password,role):
    try:
        if role == 'employee' :

            cursor.execute("SELECT email,password,employeeid FROM employee WHERE Email = %s", (email, ))
            res = cursor.fetchone()
            print(res)
            if password == res[1]:
                payload = {
                        "iss": "madhurjain",
                        "role": "employee",
                        "empid": int(res[2]),
                        "iat": int(time.time()),
                        }
                token = jwt.encode(header, payload, jwk)
                print(jwt.decode(token,jwk))
                return token
            else :
                return None
        elif role == 'admin' :
            cursor.execute("SELECT email,password FROM admin WHERE Email = %s", (email, ))
            res = cursor.fetchone()
            print(res)
            if password == res[1]:
                payload = {
                        "iss": "madhurjain",
                        "role": "admin",
                        "iat": int(time.time()),
                        }
                token = jwt.encode(header, payload, jwk)
                print(jwt.decode(token,jwk))
                return token
            else :
                return None
    
    except Exception as e:
        print(e)
        return None
    
def correct_padding(encoded_string):
    # Calculate the number of padding characters needed
    padding_needed = (4 - len(encoded_string) % 4) % 4
    # Add the padding characters
    corrected_string = encoded_string + '=' * padding_needed
    return corrected_string


def decodeToken(token):
    token = token[2:-1]
    corrected_string = correct_padding(token)
    claims = jwt.decode(token, jwk)
    return claims

