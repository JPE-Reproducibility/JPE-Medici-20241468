/* Template config.do */
/* https://github.com/AEADataEditor/replication-template/blob/master/template-config.do */
/* Copy this file to your replication directory if using Stata, e.g.,
    cp template-config.do 12345/codes/config.do

   or similar, and then add

   include "config.do"

   in the author's main Stata program

   */

/* Structure of the code, two scenarios:
   - Code looks like this (simplified, Scenario A)
         directory/
              code/
                 main.do
                 01_dosomething.do
              data/
                 data.dta
                 otherdata.dta
   - Code looks like this (simplified, Scenario B)
         directory/
               main.do
               scripts/
                   01_dosomething.do
                data/
                   data.dta
                   otherdata.dta
 - Code looks like this (simplified, Scenario C - like A, but with an additional level of directories)
         directory/
	   step1/
               scripts/
                   main.do
                   01_dosomething.do
           step2/
	       scripts/
	           othermain.do
		   01_analysis.do
           data/
               data.dta
               otherdata.dta
    For the variable "scenario" below, choose "A" or "B" (or seldomly "C"). It defaults to "A".

    NOTE: you should always put "config.do" in the same directory as "main.do"
*/

/* Scenario A: config.do and 00_master.do are both in code/; the package root is
   one level up. `cd ..` from code/ reaches MS20241468_Deposit/, which becomes
   $rootdir. Layout:
       MS20241468_Deposit/
           code/          <- config.do and 00_master.do live here
           data/public/   <- shipped aggregates read by the pipeline
           output/        <- tables, figures, logs (created on run)
*/
local scenario "A"

* SSC packages required by the runnable pipeline (code/00_master.do lines 93-95)
local ssc_packages "ftools gtools reghdfe ivreghdfe ivreg2 ranktest outreg2 coefplot grc1leg2 weakivtest2 weakivtest avar distinct estout grstyle fre acreg spmap binscatter hdfe winsor2"

local ssc_unconditional "moremata palettes colrspace egenmore"

    // If you need to "net install" packages, go to the very end of this program, and add them there.

/* The deposit bundles third-party .ado files not available on SSC in code/ado/.
   Path is relative to the package root ($rootdir), i.e. one level above code/.  */
local author_adopath "code/ado"


/* This works on all OS when running in batch mode, but may not work in interactive mode */
local pwd : pwd                     // This always captures the current directory

global rootdir "/files/JPE-Medici-20241468/replication-package/MS20241468_Deposit"
global root    "$rootdir"


/*================================================================================================================*/
/*                            You normally need to make no further changes below this                             */
/*                             unless you need to "net install" packages                                          */

/* convert paths */
global rootdir = subinstr("${rootdir}", "\", "/", .)  // Make sure slashes are correct
if "`author_adopath'" != "" {             // The author adopath variable is filled out
    local author_adopath = subinstr("`author_adopath'", "\", "/", .)  // Make sure slashes are correct
}



/* we start with all defaults set back to defaults */
set_defaults _all

/* now for some specific settings*/
set more off
/* turn on timing */
set rmsg on

cd "`pwd'"                            // Return to where we were before and never again use cd
global logdir "${rootdir}/logs"
cap mkdir "$logdir"

/* check if the author creates a log file. If not, adjust the following code fragment */

local c_date = c(current_date)
local cdate = subinstr("`c_date'", " ", "_", .)
local c_time = c(current_time)
local ctime = subinstr("`c_time'", ":", "_", .)
local ldilog = "$logdir/logfile_`cdate'-`ctime'-`c(username)'.log"
local systeminfo = "$logdir/system_`cdate'-`ctime'-`c(username)'.log"

/* global logfile */
log using "`ldilog'", name(ldi) replace text

/* capture what system we are running on */

di in red "HOSTNAME: `c(hostname)'"

/* used only for system info */
log using "`systeminfo'", name(system) replace text

/* It will provide some info about how and when the program was run */

/* install any packages locally */
di "=== Redirecting where Stata searches for ado files ==="
capture mkdir "$rootdir/ado"
adopath - PERSONAL
adopath - OLDPLACE
adopath - SITE
sysdir set PLUS     "$rootdir/ado/plus"
sysdir set PERSONAL "$rootdir/ado"       // may be needed for some packages
sysdir

/*==============================================================================================*/
/* If present, add the authors' replication-package specific ado file path                      */
/* This is defined above                                                                        */
/*==============================================================================================*/

if "`author_adopath'" != "" {             // The author adopath variable is filled out
    adopath ++ "$rootdir/`author_adopath'"
}

/* now let's check what's there */

di "=== Verifying pre-existing ado files - normally, this should be EMPTY upon first run"
adopath
ado
di "=========================="


/* this is long, so we pause the main log file */
log off ldi

di "=== SYSTEM DIAGNOSTICS ==="
creturn list
query
di "=========================="

/* we're done collecting system info */
log close system
log on ldi


/* add packages to the macro */
    
    display in red "============ Installing packages/commands from SSC ============="
    display in red "== Packages: `ssc_packages'"
    if !missing("`ssc_packages'") {
        foreach pkg in `ssc_packages' {
            capture which `pkg'
            if _rc == 111 {                 
               dis "Installing `pkg'"
                ssc install `pkg', replace
            }
            which `pkg'
        }
    }

/* add unconditionally installed packages */
    display in red "=============== Unconditionally installed packages from SSC ==============="
    display in red "== Packages: `ssc_unconditional'"
    if !missing("`ssc_unconditional'") {
        foreach pkg in `ssc_unconditional' {
            dis "Installing `pkg'"
            ssc install `pkg', replace
        }
    }

/*==============================================================================================*/
/* If you need to "net install" packages, add lines to this section                             */
    * Install packages using net
    * net install grc1leg, from("http://www.stata.com/users/vwiggins/")

/*==============================================================================================*/
/* yet other programs have no install capability, and may need to be copied */
/*==============================================================================================*/

// e.g.
//  copy (URL) (name_of_file.ado)
// example:
// copy http://www.sacarny.com/wp-content/uploads/2015/08/ebayes.ado ebayes.ado


/*==============================================================================================*/
/* This toolbox allows us to run code that still contains interactive commands (which it should not) */
/*==============================================================================================*/

net install cli-compat, all replace from("https://raw.githubusercontent.com/aeadataeditor/cli-compat-stata/master")

/*-------------- Sometimes, you may get the dreaded esttab error about paths -------------------*/
/* in that case, uncomment the following line, and overwrite the estout package with the newer one */

// net install estout, replace from(https://raw.githubusercontent.com/benjann/estout/master/)

/*==============================================================================================*/
/* after installing all packages, it may be necessary to issue the mata mlib index command */
/* This should always be the LAST command after installing all packages                    */
/*==============================================================================================*/

	mata: mata mlib index

/*==============================================================================================*/
/* This is specific to AEA replication environment. May not be needed if no confidential data   */
/* are used in the reproducibility check.                                                       */
/* Replicator should check the JIRA field "Working location of restricted data" for right path  */
/*==============================================================================================*/

global sdrive ""


/*==============================================================================================*/
/* After all the setup work, let's check again what's installed in the ado directories          */
/*==============================================================================================*/


di "=== Verifying ado files after all install steps"
adopath
ado
di "=========================="



di "========================================= END SETUP + DIAGNOSTICS ====================================" 
