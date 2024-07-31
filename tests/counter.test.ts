import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that user can vote for Biden",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const user1 = accounts.get('wallet_1')!;

        let block = chain.mineBlock([
            Tx.contractCall('counter', 'add-poll-biden', [], user1.address)
        ]);

        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);
        block.receipts[0].result.expectOk().expectTuple();
        assertEquals(block.receipts[0].events[0].type, 'stx_transfer_event');
    }
});

Clarinet.test({
    name: "Ensure that user can vote for Trump",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const user1 = accounts.get('wallet_1')!;

        let block = chain.mineBlock([
            Tx.contractCall('counter', 'add-poll-trump', [], user1.address)
        ]);

        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);
        block.receipts[0].result.expectOk().expectTuple();
        assertEquals(block.receipts[0].events[0].type, 'stx_transfer_event');
    }
});

Clarinet.test({
    name: "Ensure that user cannot vote twice",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const user1 = accounts.get('wallet_1')!;

        let block = chain.mineBlock([
            Tx.contractCall('counter', 'add-poll-biden', [], user1.address),
            Tx.contractCall('counter', 'add-poll-trump', [], user1.address)
        ]);

        assertEquals(block.receipts.length, 2);
        assertEquals(block.height, 2);
        block.receipts[0].result.expectOk();
        block.receipts[1].result.expectErr();
    }
});

Clarinet.test({
    name: "Ensure that user cannot vote without enough STX",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!;
        const poorUser = accounts.get('wallet_2')!;

        // Set balance of poorUser to 5 STX
        chain.mineBlock([
            Tx.transferSTX(5, poorUser.address, deployer.address)
        ]);

        let block = chain.mineBlock([
            Tx.contractCall('counter', 'add-poll-biden', [], poorUser.address)
        ]);

        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 3);
        block.receipts[0].result.expectErr();
    }
});

Clarinet.test({
    name: "Ensure that only contract owner can get total poll count",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!;
        const user1 = accounts.get('wallet_1')!;

        let block = chain.mineBlock([
            Tx.contractCall('counter', 'get-poll-count', [], deployer.address),
            Tx.contractCall('counter', 'get-poll-count', [], user1.address)
        ]);

        assertEquals(block.receipts.length, 2);
        assertEquals(block.height, 2);
        block.receipts[0].result.expectOk();
        block.receipts[1].result.expectErr();
    }
});

Clarinet.test({
    name: "Ensure that anyone can get individual candidate poll counts",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!;
        const user1 = accounts.get('wallet_1')!;

        chain.mineBlock([
            Tx.contractCall('counter', 'add-poll-biden', [], user1.address)
        ]);

        let block = chain.mineBlock([
            Tx.contractCall('counter', 'get-poll-biden', [], deployer.address),
            Tx.contractCall('counter', 'get-poll-trump', [], user1.address)
        ]);

        assertEquals(block.receipts.length, 2);
        assertEquals(block.height, 3);
        block.receipts[0].result.expectUint(1);
        block.receipts[1].result.expectUint(0);
    }
});

Clarinet.test({
    name: "Ensure that only contract owner can withdraw STX",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!;
        const user1 = accounts.get('wallet_1')!;

        // First, let's have a user vote to add some STX to the contract
        chain.mineBlock([
            Tx.contractCall('counter', 'add-poll-biden', [], user1.address)
        ]);

        let block = chain.mineBlock([
            Tx.contractCall('counter', 'withdraw-stx', [types.uint(5)], deployer.address),
            Tx.contractCall('counter', 'withdraw-stx', [types.uint(5)], user1.address)
        ]);

        assertEquals(block.receipts.length, 2);
        assertEquals(block.height, 3);
        block.receipts[0].result.expectOk().expectUint(5);
        block.receipts[1].result.expectErr();
    }
});

Clarinet.test({
    name: "Ensure that contract owner cannot withdraw more than contract balance",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!;
        const user1 = accounts.get('wallet_1')!;

        // First, let's have a user vote to add some STX to the contract
        chain.mineBlock([
            Tx.contractCall('counter', 'add-poll-biden', [], user1.address)
        ]);

        let block = chain.mineBlock([
            Tx.contractCall('counter', 'withdraw-stx', [types.uint(15)], deployer.address)
        ]);

        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 3);
        block.receipts[0].result.expectErr();
    }
});
