# on android, rely on SDL to get the JNI env
cdef extern JNIEnv *SDL_ANDROID_GetJNIEnv()

ctypedef (JNIENV *)(*f_android_get_jnienv)()
cdef extern from "dlfcn.h":
    ctypedef char const_char "const char"
    void *dlsym(void *handle, const_char *symbol))
    void *RTLD_GLOBAL

cdef JNIEnv *get_platform_jnienv():
    from os import environ
    symbol = environ.get('PYJNIUS_JNIENV_SYMBOL', 'SDL_ANDROID_GetJNIEnv')
    cdef char *c_symbol = symbol.encode("utf-8")
    cdef f_android_get_jnienv fn = <f_android_get_jnienv>dlsym(RTLD_GLOBAL, c_symbol)
    if fn == NULL:
        return NULL
    return fn()

    return SDL_ANDROID_GetJNIEnv()
