# inchi-gem
Ruby wrapper for [InChI]((https://github.com/IUPAC-InChI/InChI)/) v1.07.4

## Install

```
$ gem install inchi-gem
```


## Usage

```
require 'inchi-gem'

rv = Inchi::ExtraInchiReturnValues.new
inchi = Inchi::molfileToInchi(molfile, rv, "-Polymers")
// "InChI=1B/C8H8Zz2/c9-6-8(10)7-4-2-1-3-5-7/h1-5,8H,6H2/z101-1-8(10-8,9-6)"

inchi05 = Inchi::molfileToInchi(molfile, rv, "-Polymers105")
// "InChI=1B/C8H8/c1-2-8-6-4-3-5-7-8/h2-7H,1H2/z101-1-8(1.2)"

inchi = Inchi::molfileToInchi(sample_01, rv, "-Polymers -FoldCRU -NPZz -SAtZZ -LargeMolecules")
// "InChI=1B/C8H8Zz2/c9-6-8(10)7-4-2-1-3-5-7/h1-5,8H,6H2/z101-1-8(10-8,9-6)"


```

### List options:
- `LooseTSACheck` (new in v. 1.06).
    Relax strictness of tetrahedral stereo ambiguity check for stereo atoms
    in (large) rings.
    Default: Use strict criteria (as in v. 1.05 and previous).
- `Polymers`
    Experimental support of simple polymers, current mode.
    Default: Disabled.
- `Polymers105` (new in v. 1.06).
    Experimental support of simple polymers in legacy v. 1.05 mode.
    Default: Disabled.
- `NoFrameShift` (new in v. 1.06).
    Disable polymer CRU frame shift.
    Default: Attempt CRU frame shift.
- `FoldCRU` (new in v. 1.06).
    In polymer treatment, try to fold constitutional repeating units which themselves contain repeats.
    Default: Disabled.
- `NPZz` (new in v. 1.06).
    Allow non-polymer Zz pseudo element atoms.
    Default: Disabled.
- `SAtZZ` (new in v. 1.06).
    Allow stereo at atoms connected to Zz.
    Default: Disabled.
- `LargeMolecules`.
    Experimental support of molecules up to 32767 atoms.
    Default: Disabled.

### Return value

Return information is saved in the `ExtraInchiReturnValues` struct param

```
struct ExtraInchiReturnValues {
  int returnCode; // return code, see the table below
  std::string messagePtr;
  std::string logPtr;
  std::string auxInfoPtr;
};
```

Example of warning inchi

```
require 'inchi-gem'

rv = Inchi::ExtraInchiReturnValues.new
inchi = Inchi::molfileToInchi(molfile, rv, "-Polymers")
puts rv.returnCode // 1
puts rv.messagePtr // "Accepted unusual valence(s): N(4); Metal was disconnected; Proton(s) added/removed"
```

| Code              | Value | Meaning  |
| ----------------- |:-----:| ------------------------------------------------------------------------------:|
| inchi_Ret_OKAY    | 0     | Success; no errors or warnings                                                 |
| inchi_Ret_WARNING | 1     | Success; warning(s) issued                                                     |
| inchi_Ret_ERROR   | 2     | Error: no InChI has been created                                               |
| inchi_Ret_FATAL   | 3     | Severe error: no InChI has been created (typically, memory allocation failure) |
| inchi_Ret_UNKNOWN | 4     | Unknown program error                                                          |
| inchi_Ret_BUSY    | 5     | Previous call to InChI has not returned yet                                    |
| inchi_Ret_EOF     | -1    | No structural data have been provided                                          |
| inchi_Ret_SKIP    | -2    | Not used in InChI library                                                      |

## Test

```
$ rake test
```
