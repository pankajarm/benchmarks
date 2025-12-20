#!/usr/bin/env bash

# Run 10 SWE-bench Verified tasks with OpenAI GPT model
# Usage: ./run_swebench_10.sh [OPTIONS]
#
# Options:
#   --model MODEL        OpenAI model to use (default: openai/gpt-4)
#   --api-key KEY        OpenAI API key (can also use OPENAI_API_KEY env var)
#   --workspace TYPE     Workspace type: docker or remote (default: docker)
#   --num-workers N      Number of parallel workers (default: 1)
#   --max-iterations N   Maximum iterations per task (default: 100)
#   --help               Show this help message

set -euo pipefail

# Default values
MODEL="openai/gpt-4"
WORKSPACE="docker"
NUM_WORKERS=1
MAX_ITERATIONS=100
OUTPUT_DIR="./eval_outputs"
API_KEY="${OPENAI_API_KEY:-}"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --model)
            MODEL="$2"
            shift 2
            ;;
        --api-key)
            API_KEY="$2"
            shift 2
            ;;
        --workspace)
            WORKSPACE="$2"
            shift 2
            ;;
        --num-workers)
            NUM_WORKERS="$2"
            shift 2
            ;;
        --max-iterations)
            MAX_ITERATIONS="$2"
            shift 2
            ;;
        --help)
            echo "Run 10 SWE-bench Verified tasks with OpenAI GPT model"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --model MODEL        OpenAI model to use (default: openai/gpt-4)"
            echo "  --api-key KEY        OpenAI API key (can also use OPENAI_API_KEY env var)"
            echo "  --workspace TYPE     Workspace type: docker or remote (default: docker)"
            echo "  --num-workers N      Number of parallel workers (default: 1)"
            echo "  --max-iterations N   Maximum iterations per task (default: 100)"
            echo "  --help               Show this help message"
            echo ""
            echo "Examples:"
            echo "  # Run with API key from environment variable"
            echo "  export OPENAI_API_KEY='sk-your-key-here'"
            echo "  $0"
            echo ""
            echo "  # Run with API key as argument and GPT-4 Turbo"
            echo "  $0 --api-key 'sk-your-key' --model openai/gpt-4-turbo"
            echo ""
            echo "  # Run with remote workspace and 10 parallel workers"
            echo "  export RUNTIME_API_KEY='your-runtime-key'"
            echo "  $0 --workspace remote --num-workers 10"
            exit 0
            ;;
        *)
            echo "Error: Unknown option $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Check if API key is provided
if [ -z "$API_KEY" ]; then
    echo "Error: OpenAI API key is required"
    echo "Provide it via --api-key argument or OPENAI_API_KEY environment variable"
    echo "Use --help for usage information"
    exit 1
fi

# Create temporary config file
CONFIG_FILE=$(mktemp /tmp/openai-config.XXXXXX.json)
trap "rm -f $CONFIG_FILE" EXIT

cat > "$CONFIG_FILE" <<EOF
{
  "model": "$MODEL",
  "api_key": "$API_KEY"
}
EOF

echo "=========================================="
echo "SWE-bench 10-Task Evaluation"
echo "=========================================="
echo "Model: $MODEL"
echo "Workspace: $WORKSPACE"
echo "Workers: $NUM_WORKERS"
echo "Max Iterations: $MAX_ITERATIONS"
echo "Output Directory: $OUTPUT_DIR"
echo "=========================================="
echo ""

# Additional setup for docker workspace
if [ "$WORKSPACE" = "docker" ]; then
    echo "Using Docker workspace..."
    echo "Note: Set SKIP_BUILD=0 if you want to build images during runtime"
    echo "      (default is SKIP_BUILD=1, which assumes pre-built images)"
    echo ""
fi

# Additional setup for remote workspace
if [ "$WORKSPACE" = "remote" ]; then
    if [ -z "${RUNTIME_API_KEY:-}" ]; then
        echo "Warning: RUNTIME_API_KEY not set for remote workspace"
        echo "Please export RUNTIME_API_KEY before running with remote workspace"
        exit 1
    fi
    echo "Using Remote workspace with RUNTIME_API_KEY"
    echo ""
fi

# Validate config
echo "Validating LLM configuration..."
if command -v uv &> /dev/null; then
    uv run validate-cfg "$CONFIG_FILE" || {
        echo "Error: LLM configuration validation failed"
        exit 1
    }
else
    echo "Warning: 'uv' command not found, skipping validation"
    echo "Install uv or ensure dependencies are installed"
fi

echo ""
echo "Starting evaluation of 10 SWE-bench Verified instances..."
echo "This may take 2-5 hours for sequential execution (or 20-40 minutes with 10 parallel workers)"
echo ""

# Run the evaluation
if command -v uv &> /dev/null; then
    uv run swebench-infer "$CONFIG_FILE" \
        --select swebench_10_instances.txt \
        --dataset princeton-nlp/SWE-bench_Verified \
        --split test \
        --workspace "$WORKSPACE" \
        --num-workers "$NUM_WORKERS" \
        --max-iterations "$MAX_ITERATIONS" \
        --output-dir "$OUTPUT_DIR"
else
    echo "Error: 'uv' command not found"
    echo "Please install uv or run the command manually:"
    echo ""
    echo "python -m benchmarks.swebench.run_infer '$CONFIG_FILE' \\"
    echo "    --select swebench_10_instances.txt \\"
    echo "    --dataset princeton-nlp/SWE-bench_Verified \\"
    echo "    --split test \\"
    echo "    --workspace $WORKSPACE \\"
    echo "    --num-workers $NUM_WORKERS \\"
    echo "    --max-iterations $MAX_ITERATIONS \\"
    echo "    --output-dir $OUTPUT_DIR"
    exit 1
fi

echo ""
echo "=========================================="
echo "Evaluation completed!"
echo "=========================================="
echo "Results saved to: $OUTPUT_DIR"
echo ""
echo "To evaluate the results, run:"
echo "  uv run swebench-eval $OUTPUT_DIR/output.jsonl"
echo ""
