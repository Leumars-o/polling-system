# Voting Contract

## Overview

This Clarity smart contract implements a simple voting system for a hypothetical election between two candidates: Biden and Trump. Users can cast votes by sending 10 STX to the contract. The contract keeps track of votes for each candidate and the total number of votes cast.

## Contract Details

- **Contract Name**: counter
- **Language**: Clarity
- **Blockchain**: Stacks

## Features

1. Vote for either Biden or Trump
2. Each vote costs 10 STX
3. Track individual vote counts for each candidate
4. Track total vote count
5. Retrieve vote counts (restricted to contract owner)

## Data Variables

- `contract-owner`: Principal of the contract owner
- `biden-count`: Number of votes for Biden
- `trump-count`: Number of votes for Trump
- `total-poll`: Total number of votes cast

## Public Functions

### `add-poll-biden()`

Allows a user to vote for Biden.

- **Cost**: 10 STX
- **Returns**: Updated STX balance of the voter
- **Errors**: 
  - `(err u100)` if the voter doesn't have enough STX

### `add-poll-trump()`

Allows a user to vote for Trump.

- **Cost**: 10 STX
- **Returns**: A tuple containing a thank you message and the updated STX balance of the voter
- **Errors**:
  - `(err u100)` if the voter doesn't have enough STX

## Read-Only Functions

### `get-poll-count()`

Retrieves the total number of votes cast. Only accessible by the contract owner.

- **Returns**: 
  - `(ok uint)` with the total vote count if called by the contract owner
  - `(err u403)` if called by any other address

### `get-poll-biden()`

Retrieves the number of votes for Biden.

- **Returns**: Number of votes for Biden (uint)

### `get-poll-trump()`

Retrieves the number of votes for Trump.

- **Returns**: Number of votes for Trump (uint)

## Usage

To interact with this contract, you need to have a Stacks wallet with at least 10 STX tokens.

1. Deploy the contract to the Stacks blockchain.
2. To vote for Biden, call `add-poll-biden()` and send 10 STX.
3. To vote for Trump, call `add-poll-trump()` and send 10 STX.
4. The contract owner can check the total vote count by calling `get-poll-count()`.
5. Anyone can check individual candidate vote counts using `get-poll-biden()` and `get-poll-trump()`.

## Security Considerations

- Only the contract owner can retrieve the total vote count.
- Each vote requires exactly 10 STX to be sent to the contract.
- The contract does not implement any measures to prevent multiple votes from the same address.

## Future Improvements

1. Implement a mechanism to prevent multiple votes from the same address.
2. Add a function to withdraw STX from the contract (accessible only by the owner).
3. Implement a time-bound voting period.
4. Add more candidates or make the candidate list dynamic.


## Contact

Samuel

Email: samex150@gmail.com
