# Stage 1: Buld the Next.js app
FROM node:25-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./
# Install dependencies
# RUN npm ci
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .
# Build the Next.js app
RUN npm run build

# Stage 2: Run production server
FROM node:25-alpine AS runner

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Install only production dependencies
# RUN npm ci --only=production
RUN npm install --production

# Expose the port the app runs on
EXPOSE 3000

# Start the Next.js app
CMD ["npm", "next", "start"]



