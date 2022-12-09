const networkConfig = {
    // V2
    31337: {
        name: 'localhost',
        keyHash: '0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc',
        premium: '250000000000000000'
    },
    
    4: {
        name: 'rinkeby',
        //suscriptionid: '8942',
        linkToken: '0x01BE23585060835E02B77ef475b0Cc51aA1e0709',
        vrfCoordinator: '0x6168499c0cFfCaCD319c818142124B7A15E857ab',
        keyHash: '0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc', // 30 gwei
        premium: '250000000000000000'
    },

    
    80001: {
        name: 'mumbai',
        linkToken: '0x326C977E6efc84E512bB9C30f76E30c160eD06FB',
        vrfCoordinator: '0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed',
        keyHash: '0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f', // 500 gwei
        premium: '500000000000000' // 0.0005 Link
    }
    /*

    137: {
        name: 'matic mainnet',
        linkToken: '0xb0897686c545045aFc77CF20eC7A532E3120E0F1',
        vrfCoordinator: '0xAE975071Be8F8eE67addBC1A82488F1C24858067',
        keyHash: '0xcc294a196eeeb44da2888d17c0625cc88d70d9760a69d58d853ba6581a9ab0cd', // 500 gwei
        premium: '500000000000000' // 0.0005 Link
    }

    /* V1
    31337: {
        name: 'localhost',
        keyHash: '0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311',
        fee: '100000000000000000'
    },
    
    4: {
        name: 'rinkeby',
        linkToken: '0x01BE23585060835E02B77ef475b0Cc51aA1e0709',
        vrfCoordinator: '0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B',
        keyHash: '0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311',
        fee: '100000000000000000'
    }

    /*
    137: {
        name: 'matic mainnet',
        linkToken: '0xb0897686c545045aFc77CF20eC7A532E3120E0F1',
        vrfCoordinator: '0x3d2341ADb2D31f1c5530cDC622016af293177AE0',
        keyHash: '0xf86195cf7690c55907b2b611ebb7343a6f649bff128701cc542f0569e2c549da',
        fee: '100000000000000' // 0.0001 Link
    }
    */
}

module.exports = {
    networkConfig
}