window.addEventListener('load', async () => {
    if (typeof window.ethereum !== 'undefined') {
        console.log('MetaMask está instalada');

        // Conectar con MetaMask y solicitar acceso
        await ethereum.request({ method: 'eth_requestAccounts' });

        const chainId = await ethereum.request({ method: 'eth_chainId' });
        const amoyChainId = '0x13882';  

        if (chainId !== amoyChainId) {
            alert('Por favor, cambia a la red AMOY en MetaMask');
        } else {
            console.log('Conectado a la red AMOY');
            window.web3 = new Web3(window.ethereum);  // Inicializar Web3 con MetaMask

            fetch("./contractABI.json")
                .then(response => response.json())
                .then(contractABI => {
                    console.log("ABI del contrato:", contractABI);

                    const contractAddress = '0x9F17A82fAbF911e486e8A9DF2954301aa23Ea9c7';

                    window.contract = new web3.eth.Contract(contractABI, contractAddress);  // Guardar el contrato globalmente

                    console.log('Contrato creado exitosamente');
                })
                .catch((error) => {
                    console.error("Error al cargar el ABI:", error);
                });
        }
    } else {
        alert('Por favor, instala MetaMask');
    }
});

async function getBalanceOfAddress() {
    try {

        const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
        const address = accounts[0]; // Dirección de la cuenta de MetaMask

        contract.methods.balanceOf(address).call()
            .then(balance => {
                contract.methods.decimals().call()
                    .then(decimals => {
                        // Ajustar el balance eliminando los decimales son 2 para mi contrato
                        const balanceWithoutDecimals = balance / Math.pow(10, decimals);
                        // Mostrar el balance como número entero
                        document.getElementById('balanceOfAddress').innerText = `Balance: ${Math.floor(balanceWithoutDecimals)} MAR`;
                    })
                    .catch(err => console.error('Error al obtener los decimales del contrato:', err));
            })
            .catch(err => console.error('Error al obtener el balance:', err));

    } catch (error) {
        console.error('Error al obtener el balance:', error);
    }
}
async function transferTokens() {
    const toAddress = document.getElementById('toAddress').value;
    let amount = document.getElementById('amount').value;

    if (!web3.utils.isAddress(toAddress)) {
        alert('La dirección de destino no es válida.');
        return;
    }

    if (amount <= 0) {
        alert('Por favor, ingresa un monto válido.');
        return;
    }

    amount = (parseFloat(amount) * 100).toString();  // Multiplicamos por 100 para agregar los decimales

    const fromAddress = (await ethereum.request({ method: 'eth_requestAccounts' }))[0];

    try {
        document.getElementById('transferStatus').innerText = 'Transfiriendo...';

        await contract.methods.transfer(toAddress, amount).send({ from: fromAddress });

        document.getElementById('transferStatus').innerText = 'Tokens transferidos con éxito';
    } catch (error) {
        document.getElementById('transferStatus').innerText = 'Error al transferir tokens';
        console.error(error);
    }
}


async function getBalance() {
    try {
        // Solicitar cuentas de MetaMask
        const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
        const account = accounts[0];  // Obtener la primera cuenta

        console.log('Cuenta de MetaMask:', account);

        // Obtener el balance de la cuenta
        const balance = await web3.eth.getBalance(account);

		const balanceInEther = web3.utils.fromWei(balance, 'ether');
		document.getElementById('balance').innerText = `Balance: ${balanceInEther} `;

    } catch (error) {
        console.error('Error al obtener el balance:', error);
    }
}

