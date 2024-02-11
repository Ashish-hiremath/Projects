import random
import string
def encode(encodingmsg):
  if(len(encodingmsg)<=4):
    encodingmsg = "".join(reversed(encodingmsg))
    print(f"encoded msg is: {encodingmsg}")
  else:
    move=encodingmsg[0]
    mainmsg=encodingmsg[1:]
    encode1=(mainmsg+move)
    def generate_random_chars(num_chars):
      return ''.join(random.choice(string.ascii_letters) for _ in range(num_chars))
    random_chars = generate_random_chars(3)

    def generate_random_chars1(num_chars):
      return ''.join(random.choice(string.ascii_letters) for _ in range(num_chars))
    random_chars1 = generate_random_chars1(3)


    print(random_chars1+mainmsg+move+random_chars)


def decode(decodingmsg):
  if(len(decodingmsg)<=4):
   decodingmsg = "".join(reversed(decodingmsg))
   print(f"decoded msg is: {decodingmsg}")
  else:
    msg=decodingmsg[3:-3]
    
    mainmsg=''.join(reversed(msg))
    
    print(f"decoded msg is {mainmsg}")

     
command= int(input("enter 1 for encode or 2 for decode"))
if (command==1):
  encodingmsg=input("enter the message")
  print("encoding...")
  encode(encodingmsg)
  
elif (command==2):
  decodingmsg=input("enter the message")
  print("decoding...")
  decode(decodingmsg)
else:
  print("invalid command")  


    