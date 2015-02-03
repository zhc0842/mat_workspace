/*
* MATLAB Compiler: 4.17 (R2012a)
* Date: Tue Jan 27 09:57:59 2015
* Arguments: "-B" "macro_default" "-W" "dotnet:Untitled1,Class1,0.0,private" "-T"
* "link:lib" "-d" "D:\mat_workspace\deployprj\Untitled1\src" "-w"
* "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w"
* "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license"
* "-v" "class{Class1:D:\mat_workspace\MyFunc.m}" 
*/
using System;
using System.Reflection;
using System.IO;
using MathWorks.MATLAB.NET.Arrays;
using MathWorks.MATLAB.NET.Utility;

#if SHARED
[assembly: System.Reflection.AssemblyKeyFile(@"")]
#endif

namespace Untitled1
{

  /// <summary>
  /// The Class1 class provides a CLS compliant, MWArray interface to the M-functions
  /// contained in the files:
  /// <newpara></newpara>
  /// D:\mat_workspace\MyFunc.m
  /// <newpara></newpara>
  /// deployprint.m
  /// <newpara></newpara>
  /// printdlg.m
  /// </summary>
  /// <remarks>
  /// @Version 0.0
  /// </remarks>
  public class Class1 : IDisposable
  {
    #region Constructors

    /// <summary internal= "true">
    /// The static constructor instantiates and initializes the MATLAB Compiler Runtime
    /// instance.
    /// </summary>
    static Class1()
    {
      if (MWMCR.MCRAppInitialized)
      {
        Assembly assembly= Assembly.GetExecutingAssembly();

        string ctfFilePath= assembly.Location;

        int lastDelimiter= ctfFilePath.LastIndexOf(@"\");

        ctfFilePath= ctfFilePath.Remove(lastDelimiter, (ctfFilePath.Length - lastDelimiter));

        string ctfFileName = "Untitled1.ctf";

        Stream embeddedCtfStream = null;

        String[] resourceStrings = assembly.GetManifestResourceNames();

        foreach (String name in resourceStrings)
        {
          if (name.Contains(ctfFileName))
          {
            embeddedCtfStream = assembly.GetManifestResourceStream(name);
            break;
          }
        }
        mcr= new MWMCR("",
                       ctfFilePath, embeddedCtfStream, true);
      }
      else
      {
        throw new ApplicationException("MWArray assembly could not be initialized");
      }
    }


    /// <summary>
    /// Constructs a new instance of the Class1 class.
    /// </summary>
    public Class1()
    {
    }


    #endregion Constructors

    #region Finalize

    /// <summary internal= "true">
    /// Class destructor called by the CLR garbage collector.
    /// </summary>
    ~Class1()
    {
      Dispose(false);
    }


    /// <summary>
    /// Frees the native resources associated with this object
    /// </summary>
    public void Dispose()
    {
      Dispose(true);

      GC.SuppressFinalize(this);
    }


    /// <summary internal= "true">
    /// Internal dispose function
    /// </summary>
    protected virtual void Dispose(bool disposing)
    {
      if (!disposed)
      {
        disposed= true;

        if (disposing)
        {
          // Free managed resources;
        }

        // Free native resources
      }
    }


    #endregion Finalize

    #region Methods

    /// <summary>
    /// Provides a single output, 0-input MWArrayinterface to the MyFunc M-function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// sample function for c# to invoke
    /// </remarks>
    /// <returns>An MWArray containing the first output argument.</returns>
    ///
    public MWArray MyFunc()
    {
      return mcr.EvaluateFunction("MyFunc", new MWArray[]{});
    }


    /// <summary>
    /// Provides a single output, 1-input MWArrayinterface to the MyFunc M-function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// sample function for c# to invoke
    /// </remarks>
    /// <param name="x">Input argument #1</param>
    /// <returns>An MWArray containing the first output argument.</returns>
    ///
    public MWArray MyFunc(MWArray x)
    {
      return mcr.EvaluateFunction("MyFunc", x);
    }


    /// <summary>
    /// Provides a single output, 2-input MWArrayinterface to the MyFunc M-function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// sample function for c# to invoke
    /// </remarks>
    /// <param name="x">Input argument #1</param>
    /// <param name="y">Input argument #2</param>
    /// <returns>An MWArray containing the first output argument.</returns>
    ///
    public MWArray MyFunc(MWArray x, MWArray y)
    {
      return mcr.EvaluateFunction("MyFunc", x, y);
    }


    /// <summary>
    /// Provides the standard 0-input MWArray interface to the MyFunc M-function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// sample function for c# to invoke
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public MWArray[] MyFunc(int numArgsOut)
    {
      return mcr.EvaluateFunction(numArgsOut, "MyFunc", new MWArray[]{});
    }


    /// <summary>
    /// Provides the standard 1-input MWArray interface to the MyFunc M-function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// sample function for c# to invoke
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <param name="x">Input argument #1</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public MWArray[] MyFunc(int numArgsOut, MWArray x)
    {
      return mcr.EvaluateFunction(numArgsOut, "MyFunc", x);
    }


    /// <summary>
    /// Provides the standard 2-input MWArray interface to the MyFunc M-function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// sample function for c# to invoke
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <param name="x">Input argument #1</param>
    /// <param name="y">Input argument #2</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public MWArray[] MyFunc(int numArgsOut, MWArray x, MWArray y)
    {
      return mcr.EvaluateFunction(numArgsOut, "MyFunc", x, y);
    }


    /// <summary>
    /// Provides an interface for the MyFunc function in which the input and output
    /// arguments are specified as an array of MWArrays.
    /// </summary>
    /// <remarks>
    /// This method will allocate and return by reference the output argument
    /// array.<newpara></newpara>
    /// M-Documentation:
    /// sample function for c# to invoke
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return</param>
    /// <param name= "argsOut">Array of MWArray output arguments</param>
    /// <param name= "argsIn">Array of MWArray input arguments</param>
    ///
    public void MyFunc(int numArgsOut, ref MWArray[] argsOut, MWArray[] argsIn)
    {
      mcr.EvaluateFunction("MyFunc", numArgsOut, ref argsOut, argsIn);
    }



    /// <summary>
    /// This method will cause a MATLAB figure window to behave as a modal dialog box.
    /// The method will not return until all the figure windows associated with this
    /// component have been closed.
    /// </summary>
    /// <remarks>
    /// An application should only call this method when required to keep the
    /// MATLAB figure window from disappearing.  Other techniques, such as calling
    /// Console.ReadLine() from the application should be considered where
    /// possible.</remarks>
    ///
    public void WaitForFiguresToDie()
    {
      mcr.WaitForFiguresToDie();
    }



    #endregion Methods

    #region Class Members

    private static MWMCR mcr= null;

    private bool disposed= false;

    #endregion Class Members
  }
}
