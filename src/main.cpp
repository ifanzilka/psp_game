#include <pspkernel.h>
#include <pspdebug.h>
#include <pspdisplay.h>
#include <pspctrl.h>
#include <pspge.h>
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










#include <gfx.h>
#include <pspge.h>
#include <pspdisplay.h>
#include <psputils.h>

uint32_t* draw_buffer;
uint32_t* disp_buffer;



namespace GFX
{
    void    init()
    {
        draw_buffer = static_cast<uint32_t*>(sceGeEdramGetAddr());
        disp_buffer = static_cast<uint32_t*>(sceGeEdramGetAddr() + (272 * 512 * sizeof(uint32_t)));

        sceDisplaySetMode(0, 480, 271);
        sceDisplaySetFrameBuf(disp_buffer, 512, PSP_DISPLAY_PIXEL_FORMAT_8888, 1);
    }

    void    clear(uint32_t color)
    {
        for (int i = 0; i < 512 * 272; i++)
        {
            draw_buffer[i] = color;
        }
    }

    
    void    swapBuffers()
    {
        uint32_t* temp = disp_buffer;
        disp_buffer = draw_buffer;
        draw_buffer = temp; 

        sceKernelDcacheWritebackInvalidateAll();
        sceDisplaySetFrameBuf(disp_buffer, 512, PSP_DISPLAY_PIXEL_FORMAT_8888, PSP_DISPLAY_SETBUF_NEXTFRAME);
    }

    void    drawRect(unsigned int x, unsigned int y, unsigned int w, unsigned int h, uint32_t color)
    {
        if (x > 480)
        {
            x = 480;
        }
        if (y > 480)
        {
            y = 480;
        }

        if (x + w > 480)
        {
            w = 480 - x;
        }

        if (y + h > 272)
        {
            h = 272 - y;
        }

        int off = x + (y * 512);

        for (int y1 = 0; y1 < h; y1++)
        {

            for (int x1 = 0; x1 < w; x1++)
            {
                draw_buffer[x1 + off + y1 * 512] = color;
            }
        }

    }

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