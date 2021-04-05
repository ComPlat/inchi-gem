# inchi-gem
Ruby wrapper for [InChI](https://www.inchi-trust.org/downloads/) v1.06

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

inchi05 = Inchi::molfileToInchi(molfile, rv, "-Polymers105");
// "InChI=1B/C8H8/c1-2-8-6-4-3-5-7-8/h2-7H,1H2/z101-1-8(1.2)"

```

## Test

```
$ rake test
```
