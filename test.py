import cv2

# 打开电脑默认摄像头
cap = cv2.VideoCapture(0)

while True:
    # 读取画面
    success, frame = cap.read()
    if not success:
        print("无法打开摄像头！")
        break
    
    # 显示画面窗口
    cv2.imshow("My Camera", frame)
    
    # 按 'q' 键退出
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()