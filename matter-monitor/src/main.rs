use colored::*;
use std::process::Stdio;
use tokio::io::{AsyncBufReadExt, BufReader};
use tokio::process::Command;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("Starting matter-monitor...");

    // Start chip-tool as a child process.
    // Replace "interactive" with the specific chip-tool command you want to run.
    let mut child = Command::new("/usr/local/bin/chip-tool")
        .arg("interactive") // Default argument for skeleton, can be changed based on specific needs
        .arg("server")
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("Failed to spawn chip-tool");

    let stdout = child.stdout.take().expect("Failed to capture stdout");
    let stderr = child.stderr.take().expect("Failed to capture stderr");

    let mut stdout_reader = BufReader::new(stdout).lines();
    let mut stderr_reader = BufReader::new(stderr).lines();

    // Spawn a task to read stdout
    let stdout_task = tokio::spawn(async move {
        while let Ok(Some(line)) = stdout_reader.next_line().await {
            if line.contains("AttributeReport") {
                println!("{}", line.green().bold());
            } else {
                println!("{}", line);
            }
        }
    });

    // Spawn a task to read stderr
    let stderr_task = tokio::spawn(async move {
        while let Ok(Some(line)) = stderr_reader.next_line().await {
            if line.contains("AttributeReport") {
                eprintln!("{}", line.green().bold());
            } else {
                eprintln!("{}", line.red());
            }
        }
    });

    // Wait for tasks to complete
    let _ = tokio::join!(stdout_task, stderr_task);

    // Wait for the child process to exit
    let status = child.wait().await?;
    println!("chip-tool exited with status: {}", status);

    Ok(())
}
