SHHS Data Dictionary
====================

[![Build Status](https://app.travis-ci.com/nsrr/shhs-data-dictionary.svg?branch=master)](https://app.travis-ci.com/nsrr/shhs-data-dictionary)

### Exports

The SHHS data dictionary can be exported to CSV by typing the following command:

```
spout export
```

The `spout export` command will generate CSV files that describe the data
dictionary.


### Testing

The SHHS Data Dictionary is tested using the [Spout Gem](https://github.com/nsrr/spout).

Data dictionary tests can be run by typing:

```
spout test
```


### Releases

The data dictionary is tagged at various time points using
[Git tags](http://git-scm.com/book/en/Git-Basics-Tagging). The tags are used to
reference a series of CSV files that correspond to the data dictionary itself.

For example, CSV files of the underlying data that have been tagged as `v0.1.0`
will be compatible with the Data Dictionary `~> 0.1.0`,
(including `0.1.1`, `0.1.2`, `0.1.3`). However if the data dictionary contains
changes to the underlying dataset, then the minor version number is bumped, and
the patch level is reset to zero. If, for example, the CSV dataset changed to
`v0.2.0`, then it would be compatible with `0.2.0`, `0.2.1`, `0.2.2`, etc. The
approach for changing version numbers uses a variation on
[Semantic Versioning](http://semver.org).

A full list of changes for each version can be viewed in the
[CHANGELOG](https://github.com/nsrr/shhs-data-dictionary/blob/master/CHANGELOG.md).
