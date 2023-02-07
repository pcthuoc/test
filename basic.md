# Basic .NET
- Xem thông tin file thì đây là một file .NET32

    ![](https://i.imgur.com/SQ6OGOb.png)
- Chạy thử chương trình:

    ![](https://i.imgur.com/b3EILVx.png)
- Vậy là chúng ta sẽ phải nhập `name` và `key` sao cho thỏa mãn chương trình 

## Hint Button
- Khi bấm Hint mình nhận được thông báo như sau : 
    ![](https://i.imgur.com/4dQePTp.png)
- Chúng ta đã có key vậy là chỉ cần tìm được **name** là xong.

## Reverse Engineer
- Sử dụng ``Dnspy`` để Decompile ILcode.
- Mình nhanh chóng jump tới đoạn code check **name** và **password** dựa vào event button `Check` : 

    ![](https://i.imgur.com/R3VRJou.png)    

- Chúng ta có thể thấy `name` chúng ta nhập vào sẽ được `Form1.Encode` với key là `c-sharp`.
- Sau đó thì sẽ so sánh với `key` text box ở hint lúc nãy chúng ta bấm bên trên.

- Vào bên trong hàm ``Form1.Encode`` thì thấy rằng đây là hàm encrypt bằng **RC4**:
    ![](https://i.imgur.com/X3UGsLP.png)
- Vậy chúng ta đã có key và cipher, chỉ cần decrypt là ra là xong : 
    ![](https://i.imgur.com/pxq3aYN.png)

