#!/usr/bin/env python3
"""
PDF Link Crawler - Extracts all PDF links from a website

This script crawls a website, visits all pages within the same domain,
and extracts links to PDF files. Perfect for finding all FDA SSED documents
or other PDF resources on a website.

Usage:
    python3 pdf_crawler.py <starting_url> [options]

Examples:
    # Crawl FDA PMA database for PDFs
    python3 pdf_crawler.py "https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpma/pma.cfm?id=P170019" --max-pages 100

    # Crawl with custom output file
    python3 pdf_crawler.py "https://example.com" --output my_pdfs.txt --max-pages 50

    # Resume from previous crawl
    python3 pdf_crawler.py "https://example.com" --resume crawl_state.json
"""

import argparse
import json
import re
import time
from urllib.parse import urljoin, urlparse
from collections import deque
import sys

try:
    import requests
    from bs4 import BeautifulSoup
except ImportError:
    print("Error: Required packages not installed.")
    print("Install with: pip3 install requests beautifulsoup4")
    sys.exit(1)


class PDFCrawler:
    """Web crawler that extracts PDF links from websites"""

    def __init__(self, start_url, max_pages=200, delay=1.0, output_file="pdf_links.txt",
                 resume_file=None, same_domain_only=True):
        """
        Initialize the PDF crawler

        Args:
            start_url: Starting URL to begin crawling
            max_pages: Maximum number of pages to crawl
            delay: Delay between requests in seconds (be respectful!)
            output_file: File to save PDF links
            resume_file: File to save/load crawler state for resuming
            same_domain_only: Only crawl pages on the same domain
        """
        self.start_url = start_url
        self.max_pages = max_pages
        self.delay = delay
        self.output_file = output_file
        self.resume_file = resume_file or "crawler_state.json"
        self.same_domain_only = same_domain_only

        # Parse domain from start URL
        parsed = urlparse(start_url)
        self.domain = parsed.netloc
        self.scheme = parsed.scheme

        # State tracking
        self.visited_urls = set()
        self.pdf_links = set()
        self.to_visit = deque([start_url])
        self.pages_crawled = 0

        # Session for connection reuse
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (compatible; PDFCrawler/1.0; +https://github.com/)'
        })

    def is_same_domain(self, url):
        """Check if URL is on the same domain"""
        parsed = urlparse(url)
        return parsed.netloc == self.domain or parsed.netloc == ''

    def is_pdf_link(self, url):
        """Check if URL points to a PDF file"""
        parsed = urlparse(url)
        path = parsed.path.lower()
        return path.endswith('.pdf') or 'pdf' in parsed.query.lower()

    def normalize_url(self, url, base_url):
        """Normalize and join relative URLs"""
        # Handle relative URLs
        full_url = urljoin(base_url, url)

        # Parse and reconstruct to normalize
        parsed = urlparse(full_url)

        # Remove fragments
        normalized = f"{parsed.scheme}://{parsed.netloc}{parsed.path}"
        if parsed.query:
            normalized += f"?{parsed.query}"

        return normalized

    def extract_links(self, html, base_url):
        """Extract all links from HTML content"""
        soup = BeautifulSoup(html, 'html.parser')
        links = []

        # Find all anchor tags with href
        for tag in soup.find_all('a', href=True):
            href = tag['href']
            full_url = self.normalize_url(href, base_url)
            links.append(full_url)

        return links

    def crawl_page(self, url):
        """Crawl a single page and extract links"""
        try:
            print(f"[{self.pages_crawled}/{self.max_pages}] Crawling: {url}")

            response = self.session.get(url, timeout=30, allow_redirects=True)
            response.raise_for_status()

            # Only process HTML content
            content_type = response.headers.get('Content-Type', '').lower()
            if 'text/html' not in content_type:
                return []

            # Extract all links from the page
            links = self.extract_links(response.text, url)

            return links

        except requests.exceptions.RequestException as e:
            print(f"  ✗ Error crawling {url}: {e}")
            return []
        except Exception as e:
            print(f"  ✗ Unexpected error: {e}")
            return []

    def save_state(self):
        """Save crawler state for resuming later"""
        state = {
            'visited_urls': list(self.visited_urls),
            'pdf_links': list(self.pdf_links),
            'to_visit': list(self.to_visit),
            'pages_crawled': self.pages_crawled
        }

        with open(self.resume_file, 'w') as f:
            json.dump(state, f, indent=2)

        print(f"\n[STATE] Saved to {self.resume_file}")

    def load_state(self):
        """Load crawler state from file"""
        try:
            with open(self.resume_file, 'r') as f:
                state = json.load(f)

            self.visited_urls = set(state['visited_urls'])
            self.pdf_links = set(state['pdf_links'])
            self.to_visit = deque(state['to_visit'])
            self.pages_crawled = state['pages_crawled']

            print(f"[RESUME] Loaded state from {self.resume_file}")
            print(f"  - Visited: {len(self.visited_urls)} pages")
            print(f"  - Found: {len(self.pdf_links)} PDFs")
            print(f"  - Queue: {len(self.to_visit)} pages")

        except FileNotFoundError:
            print(f"[INFO] No resume file found, starting fresh")
        except Exception as e:
            print(f"[WARNING] Could not load state: {e}")

    def save_pdf_links(self):
        """Save PDF links to output file"""
        with open(self.output_file, 'w') as f:
            f.write(f"# PDF Links extracted from: {self.start_url}\n")
            f.write(f"# Total PDFs found: {len(self.pdf_links)}\n")
            f.write(f"# Pages crawled: {self.pages_crawled}\n")
            f.write(f"# Generated: {time.strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write("\n")

            for link in sorted(self.pdf_links):
                f.write(f"{link}\n")

        print(f"\n[OUTPUT] Saved {len(self.pdf_links)} PDF links to {self.output_file}")

    def crawl(self):
        """Main crawling loop"""
        print("=" * 80)
        print("PDF CRAWLER")
        print("=" * 80)
        print(f"Starting URL: {self.start_url}")
        print(f"Domain: {self.domain}")
        print(f"Max pages: {self.max_pages}")
        print(f"Delay: {self.delay}s")
        print(f"Output: {self.output_file}")
        print("=" * 80)
        print()

        try:
            while self.to_visit and self.pages_crawled < self.max_pages:
                # Get next URL to visit
                current_url = self.to_visit.popleft()

                # Skip if already visited
                if current_url in self.visited_urls:
                    continue

                # Skip if different domain (if same_domain_only is True)
                if self.same_domain_only and not self.is_same_domain(current_url):
                    continue

                # Mark as visited
                self.visited_urls.add(current_url)
                self.pages_crawled += 1

                # Crawl the page
                links = self.crawl_page(current_url)

                # Process extracted links
                pdf_count = 0
                page_count = 0

                for link in links:
                    if self.is_pdf_link(link):
                        # Found a PDF!
                        if link not in self.pdf_links:
                            self.pdf_links.add(link)
                            pdf_count += 1
                            print(f"  ✓ PDF: {link}")
                    else:
                        # Add to crawl queue if not visited
                        if link not in self.visited_urls and link not in self.to_visit:
                            if not self.same_domain_only or self.is_same_domain(link):
                                self.to_visit.append(link)
                                page_count += 1

                if pdf_count > 0 or page_count > 0:
                    print(f"  → Found: {pdf_count} PDFs, {page_count} new pages")

                # Be respectful - delay between requests
                time.sleep(self.delay)

                # Periodically save state (every 10 pages)
                if self.pages_crawled % 10 == 0:
                    self.save_state()
                    self.save_pdf_links()

        except KeyboardInterrupt:
            print("\n\n[INTERRUPTED] Crawling stopped by user")

        finally:
            # Save final results
            self.save_state()
            self.save_pdf_links()

            # Print summary
            print("\n" + "=" * 80)
            print("CRAWL COMPLETE")
            print("=" * 80)
            print(f"Pages crawled: {self.pages_crawled}")
            print(f"Pages visited: {len(self.visited_urls)}")
            print(f"PDFs found: {len(self.pdf_links)}")
            print(f"Queue remaining: {len(self.to_visit)}")
            print(f"\nResults saved to: {self.output_file}")
            print(f"State saved to: {self.resume_file}")
            print("=" * 80)


def main():
    parser = argparse.ArgumentParser(
        description='Crawl a website and extract all PDF links',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Basic crawl
  python3 pdf_crawler.py "https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpma/pma.cfm?id=P170019"

  # Limit to 50 pages with custom output
  python3 pdf_crawler.py "https://example.com" --max-pages 50 --output my_pdfs.txt

  # Resume previous crawl
  python3 pdf_crawler.py "https://example.com" --resume

  # Crawl with faster rate (1 request per 0.5 seconds)
  python3 pdf_crawler.py "https://example.com" --delay 0.5
        """
    )

    parser.add_argument('url', help='Starting URL to crawl')
    parser.add_argument('--max-pages', type=int, default=200,
                       help='Maximum number of pages to crawl (default: 200)')
    parser.add_argument('--delay', type=float, default=1.0,
                       help='Delay between requests in seconds (default: 1.0)')
    parser.add_argument('--output', default='pdf_links.txt',
                       help='Output file for PDF links (default: pdf_links.txt)')
    parser.add_argument('--resume', action='store_true',
                       help='Resume from previous crawl state')
    parser.add_argument('--resume-file', default='crawler_state.json',
                       help='State file for resuming (default: crawler_state.json)')
    parser.add_argument('--allow-external', action='store_true',
                       help='Allow crawling external domains (default: same domain only)')

    args = parser.parse_args()

    # Create crawler
    crawler = PDFCrawler(
        start_url=args.url,
        max_pages=args.max_pages,
        delay=args.delay,
        output_file=args.output,
        resume_file=args.resume_file,
        same_domain_only=not args.allow_external
    )

    # Load previous state if resuming
    if args.resume:
        crawler.load_state()

    # Start crawling
    crawler.crawl()


if __name__ == '__main__':
    main()
