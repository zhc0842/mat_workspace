/*
* MATLAB Compiler: 4.17 (R2012a)
* Date: Tue Jan 27 18:31:50 2015
* Arguments: "-B" "macro_default" "-W" "dotnet:BHahaPrj,Class1,0.0,private" "-T"
* "link:lib" "-d" "D:\mat_workspace\deployprj\BHahaPrj\src" "-w"
* "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w"
* "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license"
* "-v" "class{Class1:D:\mat_workspace\BHahaMyAdd.m,D:\mat_workspace\BHahaSMyAdd.m}" 
*/
using System;
using System.Reflection;
using System.IO;
using MathWorks.MATLAB.NET.Arrays;
using MathWorks.MATLAB.NET.Utility;

#if SHARED
[assembly: System.Reflection.AssemblyKeyFile(@"")]
#endif

namespace BHahaPrjNative
{

  /// <summary>
  /// The Class1 class provides a CLS compliant, Object (native) interface to the
  /// M-functions contained in the files:
  /// <newpara></newpara>
  /// D:\mat_workspace\BHahaMyAdd.m
  /// <newpara></newpara>
  /// D:\mat_workspace\BHahaSMyAdd.m
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

        string ctfFileName = "BHahaPrj.ctf";

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
    /// Provides a single output, 0-input Objectinterface to the BHahaMyAdd M-function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// global bHaha;
    /// </remarks>
    /// <returns>An Object containing the first output argument.</returns>
    ///
    public Object BHahaMyAdd()
    {
      return mcr.EvaluateFunction("BHahaMyAdd", new Object[]{});
    }


    /// <summary>
    /// Provides the standard 0-input Object interface to the BHahaMyAdd M-function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// global bHaha;
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public Object[] BHahaMyAdd(int numArgsOut)
    {
      return mcr.EvaluateFunction(numArgsOut, "BHahaMyAdd", new Object[]{});
    }


    /// <summary>
    /// Provides an interface for the BHahaMyAdd function in which the input and output
    /// arguments are specified as an array of Objects.
    /// </summary>
    /// <remarks>
    /// This method will allocate and return by reference the output argument
    /// array.<newpara></newpara>
    /// M-Documentation:
    /// global bHaha;
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return</param>
    /// <param name= "argsOut">Array of Object output arguments</param>
    /// <param name= "argsIn">Array of Object input arguments</param>
    /// <param name= "varArgsIn">Array of Object representing variable input
    /// arguments</param>
    ///
    [MATLABSignature("BHahaMyAdd", 0, 1, 0)]
    protected void BHahaMyAdd(int numArgsOut, ref Object[] argsOut, Object[] argsIn, params Object[] varArgsIn)
    {
        mcr.EvaluateFunctionForTypeSafeCall("BHahaMyAdd", numArgsOut, ref argsOut, argsIn, varArgsIn);
    }
    /// <summary>
    /// Provides a single output, 0-input Objectinterface to the BHahaSMyAdd M-function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <returns>An Object containing the first output argument.</returns>
    ///
    public Object BHahaSMyAdd()
    {
      return mcr.EvaluateFunction("BHahaSMyAdd", new Object[]{});
    }


    /// <summary>
    /// Provides a single output, 1-input Objectinterface to the BHahaSMyAdd M-function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="x">Input argument #1</param>
    /// <returns>An Object containing the first output argument.</returns>
    ///
    public Object BHahaSMyAdd(Object x)
    {
      return mcr.EvaluateFunction("BHahaSMyAdd", x);
    }


    /// <summary>
    /// Provides a single output, 2-input Objectinterface to the BHahaSMyAdd M-function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="x">Input argument #1</param>
    /// <param name="y">Input argument #2</param>
    /// <returns>An Object containing the first output argument.</returns>
    ///
    public Object BHahaSMyAdd(Object x, Object y)
    {
      return mcr.EvaluateFunction("BHahaSMyAdd", x, y);
    }


    /// <summary>
    /// Provides the standard 0-input Object interface to the BHahaSMyAdd M-function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public Object[] BHahaSMyAdd(int numArgsOut)
    {
      return mcr.EvaluateFunction(numArgsOut, "BHahaSMyAdd", new Object[]{});
    }


    /// <summary>
    /// Provides the standard 1-input Object interface to the BHahaSMyAdd M-function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <param name="x">Input argument #1</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public Object[] BHahaSMyAdd(int numArgsOut, Object x)
    {
      return mcr.EvaluateFunction(numArgsOut, "BHahaSMyAdd", x);
    }


    /// <summary>
    /// Provides the standard 2-input Object interface to the BHahaSMyAdd M-function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <param name="x">Input argument #1</param>
    /// <param name="y">Input argument #2</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public Object[] BHahaSMyAdd(int numArgsOut, Object x, Object y)
    {
      return mcr.EvaluateFunction(numArgsOut, "BHahaSMyAdd", x, y);
    }


    /// <summary>
    /// Provides an interface for the BHahaSMyAdd function in which the input and output
    /// arguments are specified as an array of Objects.
    /// </summary>
    /// <remarks>
    /// This method will allocate and return by reference the output argument
    /// array.<newpara></newpara>
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return</param>
    /// <param name= "argsOut">Array of Object output arguments</param>
    /// <param name= "argsIn">Array of Object input arguments</param>
    /// <param name= "varArgsIn">Array of Object representing variable input
    /// arguments</param>
    ///
    [MATLABSignature("BHahaSMyAdd", 2, 1, 0)]
    protected void BHahaSMyAdd(int numArgsOut, ref Object[] argsOut, Object[] argsIn, params Object[] varArgsIn)
    {
        mcr.EvaluateFunctionForTypeSafeCall("BHahaSMyAdd", numArgsOut, ref argsOut, argsIn, varArgsIn);
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
