import random


with open('words.txt','r') as f:
    words = f.readlines()
    new_words = []
    
    for word in words:
        new_words.append(word.replace('\n', ''))
        
    n = random.randint(0, 999)

    print(new_words[n])

    f.close()