from fastapi import FastAPI
from typing import List, Optional
import uvicorn
from pydantic import BaseModel
import urllib
import numpy as np
import requests
import cv2

app = FastAPI()
temp = []
class Item(BaseModel):
    A: list = []
    B: list = []
    C: list = []
    D: list = []
    Neg_Ques: list = []
    Neg_Mrk: int
    Pos_Mrk: int
    Url_List: list = []

def extractDigits(lst): 
	return [[el] for el in lst] 

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
        arr = myPixelVal[x]
        myIndexVal = np.where(arr>=450)
        if(len(myIndexVal[0])):
            myIndex.append(myIndexVal[0][0]+1)
        else:
            myIndex.append(0)
    print("myIndex",myIndex)
    return myIndex
   

def url_image(url):
    resp = urllib.request.urlopen(url)
    image = np.asarray(bytearray(resp.read()), dtype="uint8")
    image = cv2.imdecode(image, cv2.IMREAD_COLOR)
    return image

def image(url):
    w = 750
    h = 750
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
    crop_img1 = corners1[160:160 + 680,65:65 + 230]
    crop_img2 = corners1[160:160 + 680,445:445 + 230]

    corners2 = omr(rectCon[1],imgc,img)
    corners2_crop1 = corners2[230:230 + 420,18:18+95]
    corners2_crop2 = corners2[230:230 + 420,165:165+100]
    corners2_crop3 = corners2[230:230 + 420,315:315+100]
    corners2_crop4 = corners2[230:230 + 420,465:465+100]
    corners2_crop5 = corners2[230:230 + 420,630:630+90]

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
    user_answ = extractDigits(user_answ)

    return user_answ


def hi(a,b,c,d,e,f,g,h):
    print("a",a)
    temp = {"1":a,"2":b,"3":c,"4":d,"Neg_Ques":e,"Neg_Mrk":f,"Pos_Mrk":g,"Url_List":h}


    ques_no = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    urls = temp["Url_List"]
    print("len(urls)",len(urls))
    enroll_id = ll = np.arange(1, len(urls)+1, 1).tolist()
    print("enroll_IDS",enroll_id)
    Negmark = temp['Neg_Mrk']
    Posmark = temp['Pos_Mrk']
    neg_ques = temp['Neg_Ques']

    user_answ = []
    for url in urls:
        answ = image(url)
        res = dict(zip(ques_no, answ)) 
        user_answ.append(res)

    print("user_answ",user_answ)

    corr_answ = []
    multiple_answ = []
    for paper in user_answ:
        qset = []
        aset = []
        for ques,answ in paper.items():
            print(ques)
            print(answ)
            if len(answ) > 1:
                aset.append(1)
            else:
                aset.append(0)
            if len(answ) > 0 and answ[0]!=0:
                if ques in temp[str(answ[0])]:
                    print("+")
                    qset.append(1)
                else:
                    qset.append(0)
            elif len(answ)==0:
                qset.append(-1)
                print("*")
            else:
                qset.append(0)
                print("-")
            
        corr_answ.append(qset)
        multiple_answ.append(aset)
    print("corr_answ",corr_answ)
    print("multiple_answ",multiple_answ)
    marks = []
    for response,qno in zip(corr_answ, ques_no):
        temp_list = []
        for r in response:
            if r==0 and qno in neg_ques:
                temp_list.append(-Negmark)
            elif r==1:
                temp_list.append(Posmark)
            else:
                temp_list.append(0)
        marks.append(temp_list)
    print("marks",marks)
    percentage = []
    class_marks = []
    avg_marks = 0
    for mark in marks:
        percentage.append(np.round(sum(mark)/len(mark)*100,2))
        avg_marks = avg_marks + sum(mark)/len(mark)
        class_marks.append(sum(mark))
    avg_marks = avg_marks/len(marks)

    avg_per = np.round(sum(percentage)/len(percentage),2)

    print("percentage",percentage)
    print("class_marks",class_marks)
    print("avg_marks",avg_marks)
    print("avg_per",avg_per)

    dfa = []
    for p in percentage:
        dfa.append(p - avg_per)
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

    print("class_acc",class_acc)
    omr_error = []
    for i in multiple_answ:
        omr_error.append(sum(i))

    print("omr_error",omr_error)
    difficulty = []
    for i in accuracy:
        if i > 80:
            difficulty.append(1)
        elif i > 60 and i <= 80:
            difficulty.append(2)
        else:
            difficulty.append(3)
    print("difficulty",difficulty)
    omr_eff = 0.0
    omr_eff = np.round(100 - (sum(omr_error)/(len(ques_no)*len(enroll_id))*100),2)
    print("omr_eff",omr_eff)
    data_send = {"Enroll_id":enroll_id,"Right_Answers":freq,"Marks":class_marks,"Percentage":percentage,"OMR_Error":omr_error,"DFA":dfa,
    "Ques_No":ques_no,"Accuracy":accuracy,"Difficulty":difficulty,"Avg_Marks":avg_marks,"Top":top,"Weak":low,"Class_Accuracy":class_acc,
    "OMR_Efficiency":omr_eff}

    return data_send
    
@app.post("/answ/")
async def create_items(item: Item):
    temp = hi(item.A,item.B,item.C,item.D,item.Neg_Ques,item.Neg_Mrk,item.Pos_Mrk,item.Url_List)
    @app.post("/analytics/")
    async def create_item():
        return temp
