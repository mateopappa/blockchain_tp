# Análisis de vulnerabilidades

## Reentrancy Attack (Ataque de reentrada):

El problema más grave aquí es la vulnerabilidad de reentrada. Un atacante podría crear un contrato malicioso que llama a la función `withdraw` y, en el momento en que recibe el ETH, vuelve a llamar a `withdraw` antes de que se actualice el saldo. Esto permite al atacante drenar los fondos del contrato antes de que la función termine su ejecución.  
El atacante puede hacer múltiples llamadas recursivas y retirar más fondos de los que tiene en su saldo.

## Gas Limit en `call`:

Usar `call` para transferir ETH, aunque es más flexible que las funciones `transfer` o `send`, también puede ser menos seguro si no se manejan correctamente los límites de gas. Aunque aquí no hay un problema explícito con el gas, es importante tener cuidado con esta práctica.

# Correcciones

## Prevención de reentrancy:

Para mitigar la vulnerabilidad de reentrada, es esencial seguir el patrón de **actualizar el estado antes de realizar la transferencia de fondos**.  
Alternativamente, se puede usar un **modifier** de reentrancy guard para prevenir múltiples llamadas.

## Limitar el uso de `call`:

Considerar el uso de `transfer` o `send` si la flexibilidad de `call` no es necesaria o gestionar el éxito/fallo correctamente en caso de usar `call`.
