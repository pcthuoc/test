# AntiVM 
- Đây là một bài AntiVM, sau khi load vào IDA mình thấy có 4 lệnh antiVM nếu chúng ta truyền vào tham số: 

    ![](https://i.imgur.com/QKtBD97.png)

- Lệnh `sidt`,`sgdt`,`str`,`cpuid`
- Còn nếu không truyền vào tham số thì chúng ta có: 

    ![](https://i.imgur.com/BPI86hT.png)

## Không có tham số :  
![](https://i.imgur.com/BPI86hT.png)
- Với case này nó sẽ thực thi hàm decrypt rc4 nếu chúng ta bypass được hết những đoạn code check Virtual Machine.
- Nhìn sơ bộ thì có thể thấy v10 ở đây đóng vai trò là `key` để decrypt cipher kia. Và nó bị ảnh hưởng bới hàm **sub_4019f**.
- Phân tích hàm  **sub_4019f**: thì thấy có 10 loại check AntiVM như sau : 

### Kiểm tra Registry: 
![](https://i.imgur.com/WZeutW4.png)

- Nếu như giá trị của registry chứa những chuỗi trên thì kết luận là đang sử dụng máy ảo và giá trị đầu tiên của `key` sẽ bị sai, Hàm `cmp_registry_value` : 

```C=
int __usercall cmp_registry_value@<eax>(const WCHAR *a1@<edx>, const WCHAR *lpValueName, const WCHAR *pszSrch)
{
  HKEY phkResult; // [esp+Ch] [ebp-80Ch] BYREF
  DWORD cbData; // [esp+10h] [ebp-808h] BYREF
  WCHAR Data[1024]; // [esp+14h] [ebp-804h] BYREF

  phkResult = 0;
  memset(Data, 0, sizeof(Data));
  cbData = 260;
  if ( !RegOpenKeyExW(HKEY_LOCAL_MACHINE, a1, 0, 0x20019u, &phkResult) )
  {
    if ( !RegQueryValueExW(phkResult, lpValueName, 0, 0, (LPBYTE)Data, &cbData) && StrStrIW(Data, pszSrch) )
    {
      RegCloseKey(phkResult);
      return 1;
    }
    RegCloseKey(phkResult);
  }
  return 0;
}
```

- Vậy để bypass thì chúng ta không cho chương trình return nếu so sánh có thấy giá trị giống nhau, hay nói cách khác chúng ta sẽ sửa thành : 
```C=
int __usercall cmp_registry_value@<eax>(const WCHAR *a1@<edx>, const WCHAR *lpValueName, const WCHAR *pszSrch)
{
  HKEY phkResult; // [esp+Ch] [ebp-80Ch] BYREF
  DWORD cbData; // [esp+10h] [ebp-808h] BYREF
  WCHAR Data[1024]; // [esp+14h] [ebp-804h] BYREF

  phkResult = 0;
  memset(Data, 0, sizeof(Data));
  cbData = 260;
  if ( !RegOpenKeyExW(HKEY_LOCAL_MACHINE, a1, 0, 0x20019u, &phkResult) )
  {
    if ( !RegQueryValueExW(phkResult, lpValueName, 0, 0, (LPBYTE)Data, &cbData) && StrStrIW(Data, pszSrch) )
    {
      
    }
    RegCloseKey(phkResult);
  }
  return 0;
}
```

### Lại tiếp tục là check registry
![](https://i.imgur.com/Guh0gSl.png)
nếu hàm **RegOpenKeyExW** thành công mở được Register Key của VM thì v4 = 14. Còn nếu không phát hiện VM thì v4 = 13
- Ở đây mình cho chương trình luôn luôn cho v4=13:
![](https://i.imgur.com/CE7Sk8j.png)
### Kiểm tra file Driver của VM
![](https://i.imgur.com/eQelez3.png)
- Nếu giá trị GetFileAttributesW trả về giá trị 0x10 (FILE_ATTRIBUTE_DIRECTORY) thì sẽ lập tức phát hiện VM files trong file hệ thống, Để bypass chúng ta cho code luôn nhảy vào đoạn `v8 = v4` : 

    ![](https://i.imgur.com/d46mqkX.png)
### Kiểm tra folder 
![](https://i.imgur.com/euwDTnC.png)
- Khi debug để xem chương trình kiểm tra folder nào thì mình thấy chương trình đã kiểm tra folder `C:\\Program Files (x86)\\VMWare\\`
- Vậy để bypass thì chúng ta sẽ cho  chương trình chạy dòng `v7 = aAbcdefghijlkmn[21]`.

### Check MAC Addresses
![](https://i.imgur.com/7Nxk7Hs.png)
![](https://i.imgur.com/ozCkceR.png)
- Dùng **GetAdaptersInfo** để kiểm tra địa chỉ MAC của máy. Nếu phát hiện địa chỉ MAC mặc định của VMWare hàm ``sub_551590`` trả về 1, vậy nên để bypass chúng ta sẽ cho chương trình luôn `++v5`:

    ![](https://i.imgur.com/YSAkMXl.png)
### Check MAC 
```C=
    SizePointer = 0x288;
  ProcessHeap = GetProcessHeap();
  v9 = (struct _IP_ADAPTER_INFO *)HeapAlloc(ProcessHeap, 0, 0x288u);
  lpMem = v9;
  if ( !v9 )
  {
    sub_5519C0((wchar_t *)L"Error allocating memory needed to call GetAdaptersinfo.\n");
    v7 = -1;
    goto LABEL_31;
  }
  AdaptersInfo = GetAdaptersInfo(v9, &SizePointer);
  if ( AdaptersInfo == 111 )
  {
    v54 = lpMem;
    v11 = GetProcessHeap();
    HeapFree(v11, 0, v54);
    v55 = SizePointer;
    v12 = GetProcessHeap();
    v13 = (struct _IP_ADAPTER_INFO *)HeapAlloc(v12, 0, v55);
    lpMem = v13;
    if ( !v13 )
    {
      printf("Error allocating memory needed to call GetAdaptersinfo\n");
      v7 = 1;
      goto LABEL_31;
    }
    AdaptersInfo = GetAdaptersInfo(v13, &SizePointer);
  }
  if ( !AdaptersInfo )
  {
    v14 = (const CHAR *)lpMem;
    v15 = 0;
    do
    {
      cchWideChar = MultiByteToWideChar(0, 0, v14 + 268, -1, 0, 0);
      v16 = 2 * cchWideChar + 2;
      v17 = (WCHAR *)malloc(v16);
      psz1 = v17;
      if ( v17 )
      {
        for ( j = v17; v16; --v16 )
        {
          *(_BYTE *)j = 0;
          j = (WCHAR *)((char *)j + 1);
        }
        MultiByteToWideChar(0, 0, v14 + 268, -1, v17, cchWideChar);
        v19 = (WCHAR *)psz1;
        if ( !StrCmpIW(psz1, L"VMWare") )
          v15 = 1;
        free(v19);
        if ( v15 )
          break;
      }
      v14 = *(const CHAR **)v14;
    }
    while ( v14 );
    v69 = v15;
    v3 = v66;
    v7 = v69;
  }
  v56 = lpMem;
  v20 = GetProcessHeap();
  HeapFree(v20, 0, v56);
LABEL_31:
  v21 = 0;
  lpFileName[0] = L"\\\\.\\HGFS";
  lpFileName[1] = L"\\\\.\\vmci";
  if ( !v7 )
    v21 = 19;
  v22 = 0;
  v23 = 14;
  v3[5] = aAbcdefghijlkmn[v21];
  do
  {
    FileW = CreateFileW(lpFileName[v22], 0x80000000, 1u, 0, 3u, 0x80u, 0);
    if ( FileW != (HANDLE)-1 )
    {
      CloseHandle(FileW);
      ++v23;
    }
    ++v22;
  }
  while ( v22 < 2 );
  v25 = 0;
  v3[6] = aAbcdefghijlkmn[v23];
```
- Để ý đoạn này:

```C=
if ( !StrCmpIW(psz1, L"VMWare") )
          v15 = 1;
```

```C=
v69 = v15;
v3 = v66;
v7 = v69;
```

- Nếu 2 chuỗi giống nhau (phát hiện VM) thì hàm **StrCmpIW** return 0 => v15 = 1 => v7 = 1
- Nếu không phát hiện VM thì v23 = 19.

### Check PIPE
![](https://i.imgur.com/hcysJQF.png)
- Nếu connect được những ``PIPE`` trên thì đã phát hiện ra VM
- Để bypass thì sẽ luôn cho chương trình chạy vào v23++

### Check Process
![](https://i.imgur.com/qppqxfg.png)
- Nếu phát hiện có các tiến trình VM như trên thì sẽ **++v26** , để bypass chúng ta sẽ patch sao cho ko cho cộng ``v26`` nữa

### Check from indirect call
![](https://i.imgur.com/el9vZQF.png)
- Nếu phát hiện VM thì v27 = 11

## Có tham số
- Patch hết các lệnh check VM lạ đã liệt kê bên trên

Khi chạy file lúc không có tham số chúng ta được pass : 
![](https://i.imgur.com/BPRzZl1.png)


- Nhập lại chúng ta được : ``vcstraining{Running_in_VM_is_ridiculous}``