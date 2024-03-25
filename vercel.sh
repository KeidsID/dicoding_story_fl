echo "VERCEL_GIT_COMMIT_REF: $VERCEL_GIT_COMMIT_REF"

if [[ "$VERCEL_GIT_COMMIT_REF" == "web-release" || "$VERCEL_GIT_COMMIT_REF" == "web-preview" ]]; then
  # Proceed with the build
  echo "✅ - Build can proceed"
  exit 1

else
  # Don't build
  echo "🛑 - Build cancelled"
  exit 0
fi
