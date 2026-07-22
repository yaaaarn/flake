build-sushi:
  nixos-rebuild build-image --flake .#sushi --image-variant iso |& nom

# Edit an agenix secret
secrets-edit name:
  RULES=secrets/secrets.nix nix run github:ryantm/agenix -- -e "secrets/{{name}}.age"

# Re-encrypt all secrets (after adding new host keys)
secrets-rekey:
  RULES=secrets/secrets.nix nix run github:ryantm/agenix -- --rekey

# Edit build-time secrets (git-crypt)
secrets-values:
  $EDITOR secrets/values.nix

# Lock git-crypt (encrypts secrets)
secrets-lock:
  nix-shell -p git-crypt --run "git-crypt lock"

# Unlock git-crypt (decrypts secrets)
secrets-unlock:
  nix-shell -p git-crypt --run "git-crypt unlock"

# Show git-crypt status
secrets-status:
  nix-shell -p git-crypt --run "git-crypt status"
