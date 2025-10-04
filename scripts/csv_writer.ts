import * as csv from 'csv';
import * as fs from 'fs';

export async function writeCsv(path: string, rows: Record<string, string | number | boolean>[]) {
  const fileStream = fs.createWriteStream(path);
  await new Promise<void>((resolve, reject) => {
    csv
      .stringify(rows, {
        header: true,
        quote: true,
      })
      .pipe(fileStream)
      .on('finish', () => {
        console.log(`Successfully generated ${rows.length} rows`);
        resolve();
      })
      .on('error', reject);
  });
}
