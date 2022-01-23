# by audin 2022/01
# nim-1.6.2
# $ nimlbe install glfw glm
# glad/gl
# gcc-11.2 MinGW
# glfw-3.3.4.0
#   glfw3.dll = glfw-3.3.6.bin.WIN32 / gnu  32bit
#     https://www.glfw.org/download.html
#     If it's linked static (statick link), add -d:glfwStaticLib
# Example output:
#   [OpenGL version]: 3.3.11672 Compatibility Profile Context
#   [Vender]:   ATI Technologies Inc.
#   [Renderer]: ATI Radeon HD 3200 Graphics

# Referenced from,
#   macOSでOpenGLプログラミング（1-10. OpenGLの環境を確認する
#       https://qiita.com/sazameki/items/6b9870100a1081cedd25
# OpenGL Context
#   https://www.khronos.org/opengl/wiki/OpenGL_Context

import glfw
import glfw/wrapper
import glad/gl
import terminal
import strutils


proc openGLInfo() =
    # OpenGL base info
    echo "\n[OpenGL version]: $#" % $cast[cstring](glGetString(GL_VERSION))
    echo "[Vender]:         $#" % $cast[cstring](glGetString(GL_VENDOR))
    echo "[Renderer]:       $#" % $cast[cstring](glGetString(GL_RENDERER))
    echo "[GLSL version]:   $#" % $cast[cstring](glGetString(GL_SHADING_LANGUAGE_VERSION))

    # Texture info
    var maxTextureUnits, maxTextureSize:GLint
    glGetIntegerv(GL_MAX_TEXTURE_IMAGE_UNITS, addr maxTextureUnits)
    glGetIntegerv(GL_MAX_TEXTURE_SIZE, addr maxTextureSize)
    echo "\n[Max Texture Units]:      $#" %  $maxTextureUnits
    echo "[Max Texture Size]:       $1(width) ,$1(height)" % $maxTextureSize
    # Vertex info
    var maxIndexListVertices, maxIndexListCount: GLint
    glGetIntegerv(GL_MAX_ELEMENTS_VERTICES, addr maxIndexListVertices)
    var sVal = "N/A"
    const LIMIT_COUNT = 10000000
    if maxIndexListVertices < LIMIT_COUNT:
        sVal = $maxIndexListVertices
    echo "[Max IndexList Vertices]: $#" % $sVal
    glGetIntegerv(GL_MAX_ELEMENTS_INDICES, addr maxIndexListCount)
    sVal = "N/A"
    if maxIndexListCount < LIMIT_COUNT:
        sVal = $maxIndexListCount
    echo "[Max IndexList Count]:    $#" % $sVal
#[
let verTable = [
glv10 ,
glv11 ,
glv12 ,
glv121,
glv13 ,
glv14 ,
glv15 ,
glv20 ,
glv21 ,
glv30 ,
glv31 ,
glv32 ,
glv33 ,
glv40 ,
glv41 ,
glv42 ,
glv43 ,
glv44 ,
glv45 ,
glv46 ,
]
]#

type ProfileContext = enum
    CoreProfileContext,
    CoreProfileForwardCompatibleContext,
    CompatibilityProfileContext,
    AutoSelect


proc main() =
    glfw.initialize()
    defer: glfw.terminate()
    var mj,mi,rev:int32
    wrapper.getVersion(addr mj,addr mi,addr rev)
    echo "GLFW version $#.$#.$#" % [ $mj, $mi, $rev]

    var cfg = DefaultOpenglWindowConfig
    cfg.visible = false

    # glv10を指定すると最適な自動設定になる
    # (CompatibilityProfileContextが設定されたのと同じ)
    # デフォルトがglv10なので無指定でも同じ
    cfg.version = glv10 # glv10 is equal to autoselect.

    when false:
        #const context = CoreProfileContext
        #const context = CoreProfileForwardCompatibleContext
        #const context = CompatibilityProfileContext
        const context = AutoSelect
        case context:
            of CoreProfileContext: # >= glv32
                # [Core Profile Context] glv32以上で指定可能
                # プログラマブルシェーダーを使うならこっち
                cfg.forwardCompat = false
                cfg.profile = opCoreProfile
            of CoreProfileForwardCompatibleContext: # >= glv30
                # [Core Profile Forward-Compatible Context]
                # 古い書き方を排除する。趣味で使う時には falseが良い
                cfg.forwardCompat = true
            of CompatibilityProfileContext: # >= glv32
                # [Compatibility Profile Context]
                # Old style OpenGL compatible mode
                # 古い書き方が必要ならこっち
                # プログラマブルシェーダーも使える
                cfg.forwardCompat = false
                cfg.profile = opCompatProfile
            of AutoSelect:
                discard

    var win :glfw.Window

    win = newWindow(cfg)
    defer: win.destroy()

    if not gladLoadGL(getProcAddress):
        quit "Error initialising OpenGL"

    openGLInfo()

    # 拡張機能リストの保存
    const saveName = "openGL_ext.txt"
    var strExt = $cast[cstring](glGetString(GL_EXTENSIONS))
    writeFile(saveName,strExt.replace(" ","\n"))
    echo "\nSaved extensions to \"$#\"" % saveName

    # 終了
    echo "Pres Enter key for end"
    discard getch()

main()

