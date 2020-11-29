from fastapi import FastAPI
from typing import List, Optional
import uvicorn
from pydantic import BaseModel
import urllib
import numpy as np
import requests
import cv2


app = FastAPI()

class Item(BaseModel):
    A: list = []
    B: list = []
    C: list = []
    D: list = []
    Neg_Ques: list = []
    Neg_Mrk: int
    Pos_Mrk: int
    Url_List: list = []
    Pattern: int
    NoQues: int



def corner(crop1):
    peri = cv2.arcLength(crop1, True)
    corners = cv2.approxPolyDP(crop1, 0.02 * peri, True) 
    return corners

def reorder(myPoints):
    myPoints = myPoints.reshape((4, 2)) 
    myPointsNew = np.zeros((4, 1, 2), np.int32) 
    add = myPoints.sum(1)
    myPointsNew[0] = myPoints[np.argmin(add)]  #[0,0]
    myPointsNew[3] = myPoints[np.argmax(add)]   #[w,h]
    diff = np.diff(myPoints, axis=1)
    myPointsNew[1] = myPoints[np.argmin(diff)]  #[w,0]
    myPointsNew[2] = myPoints[np.argmax(diff)] #[h,0]
    return myPointsNew

def splitBoxes(img,qno):
    rows = np.array_split(img,qno)
    boxes=[]
    for r in rows:
        cols= np.array_split(r,4,axis=1)
        for box in cols:
            boxes.append(box)
    return boxes

def omr(crop,imgc,img):
    corners = corner(crop)
    if corners.size != 0:
        cv2.drawContours(crop, corners, -1, (0, 255, 255), 20) 
        corners = reorder(corners)
        pts1 = np.float32(corners)
        pts2 = np.float32([[0, 0],[750, 0], [0, 750],[750, 750]]) 
        matrix = cv2.getPerspectiveTransform(pts1, pts2) 
        imgWarpColored = cv2.warpPerspective(img, matrix, (750, 750)) 

        imgWarpGray = cv2.cvtColor(imgWarpColored,cv2.COLOR_BGR2GRAY)
        imgThresh = cv2.threshold(imgWarpGray, 140, 255,cv2.THRESH_BINARY_INV )[1] 
        return imgThresh

def matrix(boxes,qno):
    countR=0
    countC=0
    myPixelVal = np.zeros((qno,4))
    for image in boxes:
        totalPixels = cv2.countNonZero(image)
        myPixelVal[countR][countC]= totalPixels
        countC += 1
        if (countC==4):countC=0;countR += 1
    return myPixelVal



def user_answ_(myPixelVal,qno):
    myIndex=[]
    for x in range (0,qno):
        temp = []
        arr = myPixelVal[x]
        myIndexVal = np.where(arr >=390)
        print("myIndexVal",myIndexVal)
        print(type(myIndexVal))
        if len(myIndexVal[0])>0:
            for i in range(0, len(myIndexVal[0])):
                temp.append(int(myIndexVal[0][i])+1)
        else:
            temp.append(0)
        myIndex.append(temp)
    return myIndex
   

def url_image(url):
    resp = urllib.request.urlopen(url)
    image = np.asarray(bytearray(resp.read()), dtype="uint8")
    image = cv2.imdecode(image, cv2.IMREAD_COLOR)
    return image

def image1(url):
    w = 750
    h = 750
    x1,x2,y1,y2,y3,y4 = 160, 840, 65, 295, 445, 675
    p1, p2 = 230, 650
    img = url_image(url)
    img = cv2.resize(img,(w,h))
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    imgb = cv2.GaussianBlur(gray,(5,5),1)
    canny = cv2.Canny(imgb, 10, 50)
    imgc = img.copy()
    countours, hierarchy = cv2.findContours(canny, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    cv2.drawContours(imgc, countours, -1,(0,255,0),10)

    rectCon = []
    max_area = 0
    for i in countours:
        area = cv2.contourArea(i)
        if area > 50:
            peri = cv2.arcLength(i, True)
            approx = cv2.approxPolyDP(i, 0.02 * peri, True)
            if len(approx) == 4:
                rectCon.append(i)
    rectCon = sorted(rectCon, key=cv2.contourArea,reverse=True)

    corners1 = omr(rectCon[2],imgc,img)
    crop_img1 = corners1[x1:x2,y1:y2]
    crop_img2 = corners1[x1:x2,y3:y4]

    corners2 = omr(rectCon[1],imgc,img)
    corners2_crop1 = corners2[p1:p2,18:18+95]
    corners2_crop2 = corners2[p1:p2,165:165+100]
    corners2_crop3 = corners2[p1:p2,315:315+100]
    corners2_crop4 = corners2[p1:p2,465:465+100]
    corners2_crop5 = corners2[p1:p2,630:630+90]

    boxes1 = splitBoxes(crop_img1,5)
    boxes2 = splitBoxes(crop_img2,5)
    boxes3 = splitBoxes(corners2_crop1,2)
    boxes4 = splitBoxes(corners2_crop2,2)
    boxes5 = splitBoxes(corners2_crop3,2)
    boxes6 = splitBoxes(corners2_crop4,2)
    boxes7 = splitBoxes(corners2_crop5,2)

    mac1 = matrix(boxes1,5)
    mac2 = matrix(boxes2,5)
    mac3 = matrix(boxes3,2)
    mac4 = matrix(boxes4,2)
    mac5 = matrix(boxes5,2)
    mac6 = matrix(boxes6,2)
    mac7 = matrix(boxes7,2)
    print(mac2)

    ans1 = user_answ_(mac1,5)
    ans2 = user_answ_(mac2,5)
    ans3 = user_answ_(mac3,2)
    ans4 = user_answ_(mac4,2)
    ans5 = user_answ_(mac5,2)
    ans6 = user_answ_(mac6,2)
    ans7 = user_answ_(mac7,2)

    user_answ = ans1 + ans2 + ans3 + ans4 + ans5 + ans6 + ans7
    

    return user_answ

def image2(url):
    w = 750
    h = 750
    x1,x2,y1,y2,y3,y4 = 160, 840, 65, 295, 445, 675
    p1, p2 = 230, 650
    img = url_image(url)
    img = cv2.resize(img,(w,h))
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    imgb = cv2.GaussianBlur(gray,(5,5),1)
    canny = cv2.Canny(imgb, 10, 50)
    imgc = img.copy()
    countours, hierarchy = cv2.findContours(canny, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    cv2.drawContours(imgc, countours, -1,(0,255,0),10)

    rectCon = []
    max_area = 0
    for i in countours:
        area = cv2.contourArea(i)
        if area > 50:
            peri = cv2.arcLength(i, True)
            approx = cv2.approxPolyDP(i, 0.02 * peri, True)
            if len(approx) == 4:
                rectCon.append(i)
    rectCon = sorted(rectCon, key=cv2.contourArea,reverse=True)

    corners1 = omr(rectCon[3],imgc,img)
    corners1_crop_img1 = corners1[x1:x2,y1:y2]
    corners1_crop_img2 = corners1[x1:x2,y3:y4]

    corners2 = omr(rectCon[2],imgc,img)
    corners2_crop1 = corners2[p1:p2,18:18+95]
    corners2_crop2 = corners2[p1:p2,165:165+100]
    corners2_crop3 = corners2[p1:p2,315:315+100]
    corners2_crop4 = corners2[p1:p2,465:465+100]
    corners2_crop5 = corners2[p1:p2,630:630+90]

    corners3 = omr(rectCon[1],imgc,img)
    corners3_crop_img1 = corners3[x1:x2,y1:y2]
    corners3_crop_img2 = corners3[x1:x2,y3:y4]

    corners4 = omr(rectCon[4],imgc,img)
    corners4_crop_img1 = corners4[x1:x2,y1:y2]
    corners4_crop_img2 = corners4[x1:x2,y3:y4]

    corners5 = omr(rectCon[5],imgc,img)
    corners5_crop_img1 = corners5[x1:x2,y1:y2]
    corners5_crop_img2 = corners5[x1:x2,y3:y4]

    corners6 = omr(rectCon[6],imgc,img)
    corners6_crop_img1 = corners6[x1:x2,y1:y2]
    corners6_crop_img2 = corners6[x1:x2,y3:y4]

    boxes1 = splitBoxes(corners1_crop_img1,5)
    boxes2 = splitBoxes(corners1_crop_img2,5)
    boxes3 = splitBoxes(corners2_crop1,2)
    boxes4 = splitBoxes(corners2_crop2,2)
    boxes5 = splitBoxes(corners2_crop3,2)
    boxes6 = splitBoxes(corners2_crop4,2)
    boxes7 = splitBoxes(corners2_crop5,2)
    boxes8 = splitBoxes(corners3_crop_img1,5)
    boxes9 = splitBoxes(corners3_crop_img2,5)
    boxes10 = splitBoxes(corners4_crop_img1,5)
    boxes11 = splitBoxes(corners4_crop_img2,5)
    boxes12 = splitBoxes(corners5_crop_img1,5)
    boxes13 = splitBoxes(corners5_crop_img2,5)
    boxes14 = splitBoxes(corners6_crop_img1,5)
    boxes15 = splitBoxes(corners6_crop_img2,5)

    mac1 = matrix(boxes1,5)
    mac2 = matrix(boxes2,5)
    mac3 = matrix(boxes3,2)
    mac4 = matrix(boxes4,2)
    mac5 = matrix(boxes5,2)
    mac6 = matrix(boxes6,2)
    mac7 = matrix(boxes7,2)
    mac8 = matrix(boxes8,5)
    mac9 = matrix(boxes9,5)
    mac10 = matrix(boxes10,5)
    mac11 = matrix(boxes11,5)
    mac12 = matrix(boxes12,5)
    mac13 = matrix(boxes13,5)
    mac14 = matrix(boxes14,5)
    mac15 = matrix(boxes15,5)
    
    ans1 = user_answ_(mac1,5)
    ans2 = user_answ_(mac2,5)
    ans3 = user_answ_(mac3,2)
    ans4 = user_answ_(mac4,2)
    ans5 = user_answ_(mac5,2)
    ans6 = user_answ_(mac6,2)
    ans7 = user_answ_(mac7,2)
    ans8 = user_answ_(mac8,5)
    ans9 = user_answ_(mac9,5)
    ans10 = user_answ_(mac10,5)
    ans11 = user_answ_(mac11,5)
    ans12 = user_answ_(mac12,5)
    ans13 = user_answ_(mac13,5)
    ans14 = user_answ_(mac14,5)
    ans15 = user_answ_(mac15,5)

    user_answ = ans1 + ans2 + ans3 + ans4 + ans5 + ans6 + ans7 + ans8 + ans9 + ans10 + ans11 + ans12 + ans13 + ans14 + ans15
    

    return user_answ

def hi(a,b,c,d,e,f,g,h,i,j):
    print("a",a)
    temp = {"1":a,"2":b,"3":c,"4":d,"Neg_Ques":e,"Neg_Mrk":f,"Pos_Mrk":g,"Url_List":h, "Pattern":i, "NoQues": j}


    ques_no = np.arange(1, temp["NoQues"]+1, 1).tolist()
    ques_no_ = []
    for no in ques_no:
        ques_no_.append(str(no))
    

    urls = temp["Url_List"]
    if len(urls)==0:
        return
    print("len(urls)",len(urls))
    enroll_id = np.arange(1, len(urls)+1, 1).tolist()
    print("enroll_IDS",enroll_id)
    Negmark = temp['Neg_Mrk']
    Posmark = temp['Pos_Mrk']
    neg_ques = temp['Neg_Ques']
    pattern = temp["Pattern"]

    if Posmark==0:
        Posmark += 1

    print("##############################",neg_ques)

    if pattern == 1:
        user_answ = []
        ppl = []
        for url in urls:
            answ = image1(url)
            res = dict(zip(ques_no, answ))
            res1 = dict(zip(ques_no_,answ)) 
            user_answ.append(res)
            ppl.append(res1)
    elif pattern == 2:
        user_answ = []
        ppl = []
        for url in urls:
            answ = image2(url)
            res = dict(zip(ques_no, answ)) 
            res1 = dict(zip(ques_no_,answ)) 
            user_answ.append(res)
            ppl.append(res1)
    
    #ppl = json.dumps(ppl)
    print("user_answ",ppl)
    print("type",type(ppl[0]))
    try:
        corr_answ = []
        for paper in user_answ:
            qset = []
            for ques,answ in paper.items():
                print(ques)
                print(answ)
                if len(answ) > 0:
                    print("####")
                    if len(answ) == 1 and answ[0]!=0:
                        if ques in temp[str(answ[0])]:
                            qset.append(1)
                            print("#+")
                        else:
                            qset.append(0)
                    elif len(answ)>1:
                        cnt = 0
                        for a in answ:
                            if ques in temp[str(a)]:
                                print("##+")
                                cnt+=1
                        print("CNT",cnt)
                        if cnt == len(answ):
                            qset.append(1)
                        elif cnt!= len(answ):
                            qset.append(0)
                            print("d")
                    else:
                        qset.append(0)
                        print("###0")
                elif len(answ)==0 :
                    qset.append(-1)
                    print("*")
                else:
                    qset.append(0)
                    print("-")
                
            corr_answ.append(qset)


    
        print("corr_answ",corr_answ)

        marks = []
        neg_mark = []
        for response in corr_answ:
            temp_list = []
            neg_m = 0
            for r,qno in zip(response,ques_no):
                print("r",r,"qno",qno)
                if r==0 and qno in neg_ques:
                        temp_list.append(-Negmark)
                        neg_m = neg_m + 1
                elif r==1:
                    temp_list.append(Posmark)
                else:
                    temp_list.append(0)
            print("neg",neg_m)
            neg_mark.append(neg_m)
            marks.append(temp_list)
        print("marks",marks)
        print("nnnnnnnnnnnnn",neg_mark)
        percentage = []
        class_marks = []
        avg_marks = 0
        for mark in marks:
            percentage.append(np.round(sum(mark)/(len(ques_no)*Posmark)*100,2))
            avg_marks = avg_marks + sum(mark)/len(mark)
            class_marks.append(sum(mark))
        avg_marks = np.round(avg_marks/len(marks),2)

        avg_per = np.round(sum(percentage)/len(percentage),2)

        print("percentage",percentage)
        print("class_marks",class_marks)
        print("avg_marks",avg_marks)
        print("avg_per",avg_per)

        dfa = []
        for p in percentage:
            dfa.append(np.round((p - avg_per),2))

        top = percentage.index(max(percentage)) + 1
        low = percentage.index(min(percentage)) + 1

        print("avg_per",avg_per)
        accuracy = []
        freq = []
        for j in range(0,len(corr_answ[0])):
            acc = 0
            for i in corr_answ:
                if i[j] == 1:
                    acc+=1
            freq.append(acc)
            accuracy.append(acc/len(corr_answ)*100)
        print("accuracy",accuracy)
        print("freq",freq)

        class_acc = 0.0
        class_acc = np.round(sum(accuracy)/len(accuracy))


        difficulty = []
        for i in accuracy:
            if i > 80:
                difficulty.append("Easy")
            elif i > 60 and i <= 80:
                difficulty.append("Medium")
            else:
                difficulty.append("Hard")
        print("difficulty",difficulty)



        new_answ = []
        for i in user_answ:
            te = {}
            for p,q in i.items():
                pp = []
                for j in q:
                    print("j",j,"Q",q)
                    if j == 1:
                        pp.append('A')
                    if j == 2:
                        pp.append('B')
                    if j == 3:
                        pp.append('C')
                    if j == 4:
                        pp.append('D')
                    if j == 0:
                        pp.append('Not Marked')
                te[p] = pp
            new_answ.append(te)



        A_list = temp["1"]
        B_list = temp["2"]
        C_list = temp["3"]
        D_list = temp["4"]

        print("A_list",A_list)
        answ_key = []
        temmp = {}
        for q in ques_no:
            temmp[q] = []
        for a in A_list:
            temmp[a].append("A")
        for b in B_list:
            temmp[b].append("B")
        for c in C_list:
            temmp[c].append("C")
        for d in D_list:
            temmp[d].append("D")

        answ_key.append(temmp)
        print("tem",temmp)
        print("Answ_key",answ_key)

        print("####",new_answ)
        data_send = {"Enroll_id":enroll_id,"Right_Answers":freq,"Marks":class_marks,"Percentage":percentage,"Ned_Ques":neg_mark,"DFA":dfa,
        "Ques_No":ques_no,"Accuracy":accuracy,"Difficulty":difficulty,"Avg_Marks":avg_marks,"Top":top,"Weak":low,"Class_Accuracy":class_acc,
        "answ":new_answ,"answ_key":answ_key}
        print("data_send",data_send)
        
        return (data_send)
    except:
        return

temp = {}

@app.get("/")
async def hey():
    return "hi" 

@app.post("/answ/")
async def create_items(item:Item):
    global temp
    temp = hi(item.A,item.B,item.C,item.D,item.Neg_Ques,item.Neg_Mrk,item.Pos_Mrk,item.Url_List,item.Pattern,item.NoQues)
    print(temp)
    return

@app.post("/analytics/")
def create_item():
    global temp
    return(temp)
    

