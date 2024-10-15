# Cambios y mejoras

1. **Uso de `ReentrancyGuard` de OpenZeppelin:**
   - El contrato ahora hereda de `ReentrancyGuard`, lo que introduce el modifier `nonReentrant`. Esto previene ataques de reentrada de forma automática y confiable, sin necesidad de implementar manualmente un mecanismo de bloqueo.

2. **Uso seguro de `call`:**
   - Aunque seguimos usando `call` para la transferencia de ETH, el modifier `nonReentrant` asegura que no pueda haber múltiples llamadas a `withdraw` desde un contrato malicioso antes de actualizar el saldo.

3. **Reutilización de código probado:**
   - Al integrar OpenZeppelin, el contrato aprovecha bibliotecas que han sido ampliamente auditadas y son de confianza en la comunidad, reduciendo así la probabilidad de errores de seguridad.
