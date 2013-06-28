SHHS Data Dictionary
========================

The Sleep Heart Health Study Data Dictionary is a asyncronous multi-user curated JSON dictionary using Git for version control.

### Exports

The data dictionary can be exported to various CSV formats by typing the following commands

```
spout export
```

and

```
spout hybrid
```

The `spout export` command will generate two CSV files, one that concatentates all the variables together into a CSV file, and another file that concatenates all of the domains.


The `spout hybrid` command is used to generate a single CSV file that can be imported directly into the Sleep Portal itself.


### Testing

The SHHS Data Dictionary is tested using the [Spout Gem](https://github.com/sleepepi/spout). In order to validate various aspects of the variables and domains, a user can run the following command:

```
spout test
```


### Releases

The Data Dictionary is tagged at various time points using Git Tags. The tags are used to reference a series of SQL files that correspond to the data dictionary itself.

For example, SQL files of the underlying data that have been tagged as `v0.1.0` will be compatible with the SHHS Data Dictionary `~> 0.1.0`, (including `0.1.1`, `0.1.2`, `0.1.3`). However if the data dictionary contains changes to the underlying dataset, then the minor version number is bumped, and the patch level is reset to zero.  If, for example, the SQL dataset changed to `v0.2.0`, then it would be compatible with `0.2.0`, `0.2.1`, `0.2.2`, etc.

A full list of changes for each version can be viewed in the [CHANGELOG](https://github.com/sleepepi/shhs-data-dictionary/blob/master/CHANGELOG.md).
