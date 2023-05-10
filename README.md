# postal_expand <a href='https://degauss.org'><img src='https://github.com/degauss-org/degauss_hex_logo/raw/main/PNG/degauss_hex.png' align='right' height='138.5' /></a>

[![](https://img.shields.io/github/v/release/degauss-org/postal_expand?color=469FC2&label=version&sort=semver)](https://github.com/degauss-org/postal_expand/releases)
[![container build status](https://github.com/degauss-org/postal_expand/workflows/build-deploy-release/badge.svg)](https://github.com/degauss-org/postal_expand/actions/workflows/build-deploy-release.yaml)

## Using

If `my_address_file.csv` is a file in the current working directory with an address column named `address`, then the [DeGAUSS command](https://degauss.org/using_degauss.html#DeGAUSS_Commands):

```sh
docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/postal_expand:0.1.0 my_address_file.csv
```

will produce `my_address_file_postal_expand_0.1.0.csv` with added columns:

- **`cleaned_address`**: `address` with non-alphanumeric characterics and excess whitespace removed (with `dht::clean_address()`)

- **`expanded_addresses`**: the expanded addresses for `cleaned_address`

Addresses are be expanded into [several possible normalized addresses](https://github.com/openvenues/libpostal_expand#examples-of-normalization) using `libpostal_expand`.  This can be useful for matching of these addresses with other messy, real world addresses.

Because each `cleaned_address` will likely result in more than one `expanded_addresses`, each input row is duplicated to accomodate several `expanded_addresses`. This means that when expanding addresses, the input CSV file is "expanded" too by duplicating the input rows.

## Geomarker Methods

Input addresses are normalized using [`libpostal_expand`](https://github.com/openvenues/libpostal_expand) by:

1. removing non-alphanumeric characters (except `-`) and excess whitespace (with `dht::clean_address()`)
2. expanding the cleaned address into [several possible normalized addresses](https://github.com/openvenues/libpostal_expand#examples-of-normalization)

## DeGAUSS Details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS homepage](https://degauss.org).
