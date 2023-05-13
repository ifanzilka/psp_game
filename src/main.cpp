#include <pspkernel.h>
#include <pspdebug.h>
#include <pspdisplay.h>
#include <pspctrl.h>
#include <pspge.h>

//
#include <gfx.h>

//#include <unistd.h>
//##include<time.h>

#define printf pspDebugScreenPrintf

PSP_MODULE_INFO("Tutorial", 0, 1, 0);

int exit_callback(int arg1, int arg2, void *common)
{
    sceKernelExitGame();
    return (0);

}

int callbackThread(SceSize args, void *argptr)
{
    int cbind = sceKernelCreateCallback("Exit callback.", exit_callback, NULL);
    sceKernelRegisterExitCallback(cbind);
    sceKernelSleepThreadCB();
    return (0);
}

int setupCallBacks()
{
    int thid = sceKernelCreateThread("update_thread", callbackThread, 0x11, 0xFA0, 0, NULL);

    if (thid > 0)
    {
        sceKernelStartThread(thid, 0, NULL);
    }
    return (thid);
}


int main()
{
    setupCallBacks();
    GFX::init();

    while (true)
    {
        GFX::clear(0xFFFFCA82);

        GFX::drawRect(10,10 ,30, 30,0xFF00FFFF);
        GFX::swapBuffers();

        sceDisplayWaitVblankStart();
    }

    return (0);
}









int main2()
{
    setupCallBacks();
    
    pspDebugScreenInit();
    pspDebugScreenPrintf("Hello my world\n");
   
    sceCtrlSetSamplingCycle(0);
    sceCtrlSetSamplingMode(PSP_CTRL_MODE_ANALOG);

    SceCtrlData ctrlData;

    while (true)
    {
        sceCtrlReadBufferPositive(&ctrlData, 1);

        if (ctrlData.Buttons & PSP_CTRL_CROSS)
        {
            pspDebugScreenPrintf("CROSS PRESSED\n");
        }

        if (ctrlData.Buttons & PSP_CTRL_TRIANGLE)
        {
            pspDebugScreenPrintf("TRIANGLE PRESSED\n");
        }

        if (ctrlData.Buttons & PSP_CTRL_CIRCLE)
        {
            pspDebugScreenPrintf("CIRCLE PRESSED\n");
        }

        if (ctrlData.Buttons & PSP_CTRL_SQUARE)
        {
            pspDebugScreenPrintf("SQUARE PRESSED\n");
        }



    }
    
    return (0);
}



// int main(void) 
// {       
// 	pspDebugScreenInit();
// 	//setupExitCallback();

// 	while(true)
// 	{
// 		pspDebugScreenSetXY(0, 0);
// 		printf("Hello World!");
// 		sceDisplayWaitVblankStart();
// 	}

// 	sceKernelExitGame();	

// 	return 0;
// }