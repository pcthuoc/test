# Imposter Dot Net

![](https://i.imgur.com/dh9KiGX.png)

- Tiếp tục với .NET 
- Mình chạy thử chương trình: 

![](https://i.imgur.com/IofxKqJ.png)

- Lại tiếp tục decompile với **Dnspy**: 
- Đến với đoạn code trigger nút ***Vote***:

    ![](https://i.imgur.com/6MtT4KX.png)
- Mình thử bấm vào xem hàm ***CreateHash*** thì thấy nó lại gọi đến một hàm khác nữa : 
    ![](https://i.imgur.com/lRbydDS.png)
- Và hàm này lại gọi đến một hàm khác nữa : 

![](https://i.imgur.com/mE4umS1.png)

- Sau khi bấm nát chuột thì mình đến được chỗ cần đọc : 

    ![](https://i.imgur.com/JfJVFHa.png)
- Vậy là nó sẽ tạo hash **MD5**
- Sau đó dùng kết quả hash đó để encode với key là `among-us`, và rồi so sánh với `"40-72-b1-25-9e-ff-83-f3-07-c4-e8-d6-8a-a6-0c-e0-ef-9f-a6-3f-e2-fc-0b-81-2a-47-dd-8b-1a-a3-4c-32".
- Hàm Encode cũng lại là **RC4** nên mình nhanh chóng decrypt : 
    ![](https://i.imgur.com/vqCZxOc.png)
- Mình lấy lại được chuỗi **MD5** nhưng mình không thể crack được mã hash này nên mình lên gg ném vào crack station thì được kết quả là : 

![](https://i.imgur.com/r8G6tZD.png)

- Vậy chúng ta được kết quả là `.NET`

![](https://i.imgur.com/kbi90d5.png)
