package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"path"
	"strings"

	"hostman/consts"

	"github.com/earlye/eaux/go/cobra/slogx"
	"github.com/spf13/cobra"
)

type hostBlock struct {
	marker string
	hosts  []string
}

func listHostBlocks() ([]hostBlock, error) {
	data, err := os.ReadFile(hostsFile)
	if err != nil {
		return nil, fmt.Errorf("failed to read %s: %w", hostsFile, err)
	}

	var blocks []hostBlock
	var current *hostBlock

	scanner := bufio.NewScanner(bytes.NewReader(data))
	for scanner.Scan() {
		line := scanner.Text()
		if strings.HasPrefix(line, "# BEGIN ") {
			marker := strings.TrimPrefix(line, "# BEGIN ")
			current = &hostBlock{marker: marker}
		} else if strings.HasPrefix(line, "# END ") {
			if current != nil {
				blocks = append(blocks, *current)
				current = nil
			}
		} else if current != nil {
			current.hosts = append(current.hosts, line)
		}
	}

	return blocks, scanner.Err()
}

func matchesAnyGlob(marker string, globs []string) bool {
	if len(globs) == 0 {
		return true
	}
	for _, g := range globs {
		if matched, err := path.Match(g, marker); err == nil && matched {
			return true
		}
	}
	return false
}

var lsCmd = &cobra.Command{
	Use:   "ls [glob...]",
	Short: "List marked blocks in /etc/hosts",
	Long:  `List all marked blocks present in /etc/hosts. Optionally filter by glob patterns on the marker name.`,
	Args:  cobra.ArbitraryArgs,
	RunE: func(cmd *cobra.Command, args []string) error {
		showAll, err := cmd.Flags().GetBool("all")
		if err != nil {
			return err
		}

		blocks, err := listHostBlocks()
		if err != nil {
			return err
		}

		for _, block := range blocks {
			if !matchesAnyGlob(block.marker, args) {
				continue
			}
			fmt.Println(block.marker)
			if showAll {
				for _, host := range block.hosts {
					fmt.Printf("  %s\n", host)
				}
			}
		}
		return nil
	},
}

const hostsFile = "/etc/hosts"

func addHostEntries(marker string, hosts []string) error {
	if len(hosts) == 0 {
		return nil
	}

	if err := removeHostEntries(marker); err != nil {
		return err
	}

	data, err := os.ReadFile(hostsFile)
	if err != nil {
		return fmt.Errorf("failed to read %s: %w", hostsFile, err)
	}

	var block strings.Builder
	block.Write(data)
	block.WriteString(fmt.Sprintf("\n# BEGIN %s\n", marker))
	for _, host := range hosts {
		block.WriteString(host + "\n")
	}
	block.WriteString(fmt.Sprintf("# END %s\n", marker))

	if err := os.WriteFile(hostsFile, []byte(block.String()), 0644); err != nil {
		return fmt.Errorf("failed to add host entries: %w", err)
	}

	return nil
}

func removeHostEntries(marker string) error {
	data, err := os.ReadFile(hostsFile)
	if err != nil {
		return fmt.Errorf("failed to read %s: %w", hostsFile, err)
	}

	content := string(data)
	beginMarker := fmt.Sprintf("# BEGIN %s", marker)
	endMarker := fmt.Sprintf("# END %s", marker)

	beginIdx := strings.Index(content, beginMarker)
	if beginIdx == -1 {
		return nil
	}

	endIdx := strings.Index(content, endMarker)
	if endIdx == -1 {
		return fmt.Errorf("found BEGIN marker but no END marker for %q", marker)
	}

	endIdx += len(endMarker)
	if endIdx < len(content) && content[endIdx] == '\n' {
		endIdx++
	}

	if beginIdx > 0 && content[beginIdx-1] == '\n' {
		beginIdx--
	}

	newContent := content[:beginIdx] + content[endIdx:]

	if err := os.WriteFile(hostsFile, []byte(newContent), 0644); err != nil {
		return fmt.Errorf("failed to update host entries: %w", err)
	}

	return nil
}

var addCmd = &cobra.Command{
	Use:   "add <marker> <json-array>",
	Short: "Add host entries to /etc/hosts",
	Long: `Add host entries to /etc/hosts, bracketed by BEGIN/END marker comments.

The json-array argument must be a JSON-encoded array of host line strings, e.g.:
  '["127.0.0.1 foo.example.com","127.0.0.1 bar.example.com"]'

Any existing block with the same marker is replaced.`,
	Args: cobra.ExactArgs(2),
	RunE: func(cmd *cobra.Command, args []string) error {
		marker := args[0]
		var hosts []string
		if err := json.Unmarshal([]byte(args[1]), &hosts); err != nil {
			return fmt.Errorf("failed to parse json-array: %w", err)
		}
		return addHostEntries(marker, hosts)
	},
}

var rmCmd = &cobra.Command{
	Use:   "rm <marker>",
	Short: "Remove host entries from /etc/hosts",
	Long:  `Remove the block of host entries bracketed by BEGIN/END marker comments from /etc/hosts.`,
	Args:  cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		return removeHostEntries(args[0])
	},
}

var rootCmd = &cobra.Command{
	Use:          "hostman",
	Short:        "Manage /etc/hosts entries",
	Long:         `hostman adds and removes bracketed blocks of entries in /etc/hosts. Requires root privileges.`,
	Version:      consts.Version,
	SilenceUsage: true,
	PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
		return slogx.SlogPreRunE(cmd, args)
	},
}

func init() {
	slogx.AddPersistentFlags(rootCmd, slogx.Options{
		VerbosityDefault: "INFO",
		LogFormatDefault: "text",
	})
	lsCmd.Flags().BoolP("all", "a", false, "Include host entries within each block")
	rootCmd.AddCommand(addCmd)
	rootCmd.AddCommand(rmCmd)
	rootCmd.AddCommand(lsCmd)
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
