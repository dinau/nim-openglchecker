### nim-openglchecker

Very simple tool for checking OpenGL version.

### Run on Window10

```sh
> openglCheckerNim.exe 
```

#### Shown result in

```sh
GLFW version 3.3.6

[OpenGL version]: 3.3.11672 Compatibility Profile Context
[Vender]:         ATI Technologies Inc.
[Renderer]:       ATI Radeon HD 3200 Graphics
[GLSL version]:   3.30

[Max Texture Units]:      16
[Max Texture Size]:       8192(width) ,8192(height)
[Max IndexList Vertices]: N/A
[Max IndexList Count]:    N/A

Saved extensions to "openGL_ext.txt"
Pres Enter key for end
```

#### Build and run from source code 

```sh
$ nimble run
```

or

```sh
> make
```

Confirmed only on Windows10 environment at this moment.

#### Memo 

* glfw-3.3.4.0
  * glfw3.dll = glfw-3.3.6.bin.WIN32 / gnu  32bit
    * https://www.glfw.org/download.html
    * If it's linked static (statick link), add -d:glfwStaticLib
* Referenced from,
  * macOSでOpenGLプログラミング（1-10. OpenGLの環境を確認する)
        https://qiita.com/sazameki/items/6b9870100a1081cedd25
* OpenGL Context  
    https://www.khronos.org/opengl/wiki/OpenGL_Context
