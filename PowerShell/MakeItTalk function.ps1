<#
.SYNOPSIS
    Make your computer talk
.DESCRIPTION
    Make your computer talk
.PARAMETER thingToSay
    The thing to say
.PARAMETER gender
    male or female
#>
function MakeItTalk 
{[CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string] $thingToSay,

        [Parameter(Mandatory=$false)]
        [ValidateSet("male","female")]
        [string] $gender = "female"
    )

    #set up a type class to access the mute/unmute functions
    try { [Audio] | out-null } catch { Add-Type -TypeDefinition @'
    using System.Runtime.InteropServices;
    
    [Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IAudioEndpointVolume {
      // f(), g(), ... are unused COM method slots. Define these if you care
      int f(); int g(); int h(); int i();
      int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
      int j();
      int GetMasterVolumeLevelScalar(out float pfLevel);
      int k(); int l(); int m(); int n();
      int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
      int GetMute(out bool pbMute);
    }
    [Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IMMDevice {
      int Activate(ref System.Guid id, int clsCtx, int activationParams, out IAudioEndpointVolume aev);
    }
    [Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IMMDeviceEnumerator {
      int f(); // Unused
      int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
    }
    [ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }
    
    public class Audio {
      static IAudioEndpointVolume Vol() {
        var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
        IMMDevice dev = null;
        Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(/*eRender*/ 0, /*eMultimedia*/ 1, out dev));
        IAudioEndpointVolume epv = null;
        var epvid = typeof(IAudioEndpointVolume).GUID;
        Marshal.ThrowExceptionForHR(dev.Activate(ref epvid, /*CLSCTX_ALL*/ 23, 0, out epv));
        return epv;
      }
      public static float Volume {
        get {float v = -1; Marshal.ThrowExceptionForHR(Vol().GetMasterVolumeLevelScalar(out v)); return v;}
        set {Marshal.ThrowExceptionForHR(Vol().SetMasterVolumeLevelScalar(value, System.Guid.Empty));}
      }
      public static bool Mute {
        get { bool mute; Marshal.ThrowExceptionForHR(Vol().GetMute(out mute)); return mute; }
        set { Marshal.ThrowExceptionForHR(Vol().SetMute(value, System.Guid.Empty)); }
      }
    }
'@    
}
    # Check if the audio is muted
    $isCurrentlymuted = [audio]::Mute

    # Unmute if muted
    if ($isCurrentlymuted) 
    {
        [audio]::Mute = $false  
    } 

    # Speak
    Add-Type -AssemblyName System.Speech
    $synth = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
    if ($gender -eq "female")
    {
        $synth.SelectVoice("Microsoft Zira Desktop")
    }
    else
    {
        $synth.SelectVoice("Microsoft David Desktop")
    }
    $synth.Volume = 100

    
    $synth.Speak("$thingToSay")
    write-output $thingToSay

    #remute if it was muted
    if ($isCurrentlymuted) 
    {
        [audio]::Mute = $true 
    } 
}
