// Asegúrate de tener Metamask instalada y conectada
window.addEventListener('load', async () => {
    if (typeof window.ethereum !== 'undefined') {
        console.log('Metamask está instalada');
        await ethereum.request({ method: 'eth_requestAccounts' }); // Solicita acceso a Metamask
        window.web3 = new Web3(window.ethereum); // Conectar a Metamask
    } else {
        alert('Por favor, instala Metamask');
    }
});

// Dirección y ABI del contrato (reemplázalos con tu información)
const contractAddress = 0x006F7Be5A8b97b402C95f47990Db4aD5894891ea;
const contractABI = [ /* TU_CONTRACT_ABI */ ];

const contract = new web3.eth.Contract(contractABI, contractAddress);

// Función para guardar un número en el contrato
function setNumber() {
    const number = document.getElementById('numberInput').value;
    web3.eth.getAccounts().then(accounts => {
        const account = accounts[0];
        contract.methods.setNumber(number).send({ from: account })
            .then(() => {
                console.log('Número guardado en el contrato');
            })
            .catch(err => console.error('Error al guardar el número:', err));
    });
}

// Función para obtener el número almacenado
function getNumber() {
    contract.methods.getNumber().call()
        .then(result => {
            document.getElementById('storedNumber').innerText = `Número almacenado: ${result}`;
        })
        .catch(err => console.error('Error al obtener el número:', err));
}
